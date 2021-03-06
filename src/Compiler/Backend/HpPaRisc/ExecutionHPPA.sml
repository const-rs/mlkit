
functor ExecutionHPPA(BuildCompile : BUILD_COMPILE) : EXECUTION =
  struct
    structure ExecutionArgs = BuildCompile.ExecutionArgs
    open ExecutionArgs

    structure Basics = Elaboration.Basics
    structure TopdecGrammar = Elaboration.PostElabTopdecGrammar
    structure Tools = Basics.Tools
    structure AllInfo = Basics.AllInfo
    structure PP = Tools.PrettyPrint
    structure Name = Basics.Name
    structure IntFinMap = Tools.IntFinMap
    structure Flags = Tools.Flags
    structure Report = Tools.Report
    structure Crash = Tools.Crash

    structure HpPaRisc = HpPaRisc(structure Labels = Labels
				  structure Lvars = Lvars
				  structure Lvarset = Lvarset
				  structure Crash = Crash
				  structure PP = PP)

    structure BackendInfo = 
      BackendInfo(structure Labels = Labels
		  structure PP = PP
		  structure Flags = Flags
		  structure Report = Report
		  structure Crash = Crash
		  val down_growing_stack : bool = false        (* false for HPPA code generation *)
		  val double_alignment_required : bool = true  (* true for HPPA code generation *)
		  val extra_prims = nil)

    structure NativeCompile = NativeCompile(open ExecutionArgs
					    open BuildCompile
					    structure BackendInfo = BackendInfo
					    structure RegisterInfo = HpPaRisc.RI)

    structure CompileBasis = CompileBasis(structure CompBasis = BuildCompile.CompBasis
					  structure ClosExp = NativeCompile.ClosExp
					  structure PP = PP
					  structure Flags = Flags)

    structure JumpTables = JumpTables(structure BI = BackendInfo
				      structure Crash = Crash)

    structure HppaResolveJumps =
      HppaResolveJumps(structure HpPaRisc = HpPaRisc
		       structure Labels = Labels
   		       structure Crash = Crash
		       structure IntFinMap = IntFinMap)

    structure HpPaDelaySlotOptimization =
      HpPaDelaySlotOptimization(structure HpPaRisc = HpPaRisc
				structure Flags = Tools.Flags
				structure Crash = Tools.Crash)

    structure CodeGen = CodeGen(structure BI = BackendInfo
				structure HpPaRisc = HpPaRisc
				structure JumpTables = JumpTables
				structure HppaResolveJumps = HppaResolveJumps
				structure Con = Con
				structure Excon = Excon
				structure Lvars = Lvars
				structure Lvarset = Lvarset
				structure Labels = Labels
				structure CallConv = NativeCompile.CallConv
				structure LineStmt = NativeCompile.LineStmt
				structure SubstAndSimplify = NativeCompile.SubstAndSimplify
				structure PP = PP
				structure Flags = Tools.Flags
				structure Report = Tools.Report
				structure Crash = Tools.Crash)


    structure Compile = BuildCompile.Compile
    structure CompilerEnv = BuildCompile.CompilerEnv

    val backend_name = "HPPA"

    (****************************************************************)
    (* Add Dynamic Flags                                            *)
    (****************************************************************)

    val _ = Flags.add_bool_entry
      {long="delay_slot_optimization", short=NONE,item=ref true,neg=true,
       menu=["Control", "delay slot optimization"], desc=""}

    val _ = Flags.add_bool_entry
       {long="delete_target_files", short=NONE, neg=true, item=ref true,
	menu=["Debug", "delete target files"], 
	desc="Delete assembler files produced by the compiler. If you\n\
	 \disable this flag, you can inspect the assembler code\n\
	 \produced by the compiler."}

    val dso_flag = Flags.lookup_flag_entry "delay_slot_optimization"

    val _ = Flags.add_string_entry 
      {long="clibs", short=NONE, item=ref "-lM",
       menu=["Control", "clibs"],
       desc="If you have added your own object files to a project, you\n\
	\might also need to link with libraries other than\n\
	\libM.so (\"-lM\")."}

    type CompileBasis = CompileBasis.CompileBasis
    type CEnv = BuildCompile.CompilerEnv.CEnv
    type strdec = TopdecGrammar.strdec
    type target = CodeGen.AsmPrg
    type label = NativeCompile.label

    type linkinfo = {code_label:label, imports: label list * label list, exports : label list * label list, unsafe:bool}
    fun code_label_of_linkinfo (li:linkinfo) = #code_label li
    fun exports_of_linkinfo (li:linkinfo) = #exports li
    fun imports_of_linkinfo (li:linkinfo) = #imports li
    fun unsafe_linkinfo (li:linkinfo) = #unsafe li
    fun mk_linkinfo a : linkinfo = a

    datatype res = CodeRes of CEnv * CompileBasis * target * linkinfo
                 | CEnvOnlyRes of CEnv

    fun compile (ce, CB, strdecs, vcg_file) : res =
      let val (cb,closenv) = CompileBasis.de_CompileBasis CB
      in case Compile.compile (ce, cb, strdecs, vcg_file)
	   of Compile.CEnvOnlyRes ce => CEnvOnlyRes ce
	    | Compile.CodeRes(ce,cb,target,safe) => 
	     let 
	       val (closenv, target_new) = NativeCompile.compile(closenv,target,safe)
	       val {main_lab, code, imports, exports, safe} = target_new
	       val asm_prg = Tools.Timing.timing "CG" CodeGen.CG target_new
	       val asm_prg_dso =
		 if !dso_flag then Tools.Timing.timing "DSO" HpPaDelaySlotOptimization.DSO asm_prg
		 else asm_prg
	       val linkinfo = mk_linkinfo {code_label=main_lab,
					   imports=imports, (* (MLFunLab,DatLab) *)
					   exports=exports, (* (MLFunLab,DatLab) *)
					   unsafe=not(safe)}
	       val CB = CompileBasis.mk_CompileBasis(cb,closenv)
	     in 
	       CodeRes(ce,CB,asm_prg,linkinfo)
	     end
      end

    val generate_link_code = 
      SOME (fn (labs,exports) =>
	    if !dso_flag then HpPaDelaySlotOptimization.DSO (CodeGen.generate_link_code (labs,exports))
	    else CodeGen.generate_link_code (labs,exports))
      

    fun delete_file f = OS.FileSys.remove f handle _ => ()
    fun execute_command command : unit =
      (OS.Process.system command; ())
(*      handle OS.SysErr(s,_) => die ("\nCommand " ^ command ^ "\nfailed (" ^ s ^ ");") *)
  
    val delete_target_files = Flags.lookup_flag_entry "delete_target_files"
    val clibs = Flags.lookup_string_entry "clibs"
    fun assemble (file_s, file_o) =
      (execute_command (!(Flags.lookup_string_entry "c_compiler") ^ " -c -o " ^ file_o ^ " " ^ file_s);
       if !delete_target_files then delete_file file_s 
       else ())

	  (*e.g., "cc -Aa -c -o link.o link.s"

	   man cc:
	   -c          Suppress the link edit phase of the compilation, and
		       force an object (.o) file to be produced for each .c
		       file even if only one program is compiled.  Object
		       files produced from C programs must be linked before
		       being executed.

	   -ooutfile   Name the output file from the linker outfile.  The
		       default name is a.out.*)

    fun emit {target, filename:string} : string =
      let val filename_o = filename ^ ".o"
	  val filename_s = filename ^ ".s"
      in CodeGen.emit (target, filename_s);
	assemble(filename_s, filename_o);
	filename_o
      end

    fun link_files_with_runtime_system path_to_runtime files run =
      let val files = map (fn s => s ^ " ") files
	  val shell_cmd = !(Flags.lookup_string_entry "c_compiler") ^ " -o " ^ run ^ " " ^ 
	    concat files ^ path_to_runtime() ^ " " ^ !clibs
      in execute_command shell_cmd;
	TextIO.output (TextIO.stdOut, "[wrote executable file:\t" ^ run ^ "]\n")
      end 

  end;
