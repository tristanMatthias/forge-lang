; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Cli = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%CommandList = type { i64, ptr }
%FlagList = type { i64, ptr }
%OptionList = type { i64, ptr }
%ArgList = type { i64, ptr }
%CommandDef = type { ptr, ptr, ptr, ptr, ptr }
%FlagDef = type { ptr, ptr, ptr }
%OptionDef = type { ptr, ptr, ptr, ptr }
%ArgDef = type { ptr, ptr, i1 }
%ParsedOptionList = type { i64, ptr }
%ParsedOption = type { ptr, ptr }
%ParsedFlagList = type { i64, ptr }
%ParsedArgList = type { i64, ptr }
%ParseResult = type { ptr, ptr, ptr, ptr, ptr }
%ParsedFlag = type { ptr, i1 }
%ParsedArg = type { ptr, ptr }
%ParsedArgList__Node = type { ptr, ptr }
%ParsedOptionList__Node = type { ptr, ptr }
%ParsedFlagList__Node = type { ptr, ptr }
%CommandList__Node = type { ptr, ptr }
%ArgList__Node = type { ptr, ptr }
%OptionList__Node = type { ptr, ptr }
%FlagList__Node = type { ptr, ptr }

@fld_name = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.1 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.2 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.3 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.5 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.6 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.7 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.8 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.9 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn = private unnamed_addr constant [21 x i8] c"update_command_flags\00", align 1
@mu_file = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.10 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.11 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.12 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.13 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.14 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.15 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.16 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.17 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.18 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.19 = private unnamed_addr constant [23 x i8] c"update_command_options\00", align 1
@mu_file.20 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.21 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.22 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.23 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.24 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.25 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.26 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.27 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.28 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.29 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.30 = private unnamed_addr constant [20 x i8] c"update_command_args\00", align 1
@mu_file.31 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.32 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@fld_name.33 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.34 = private unnamed_addr constant [8 x i8] c"FlagDef\00", align 1
@src_file.35 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.36 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.37 = private unnamed_addr constant [8 x i8] c"FlagDef\00", align 1
@src_file.38 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.39 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.40 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.41 = private unnamed_addr constant [8 x i8] c"FlagDef\00", align 1
@src_file.42 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.43 = private unnamed_addr constant [14 x i8] c"is_flag_match\00", align 1
@mu_file.44 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.45 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.46 = private unnamed_addr constant [10 x i8] c"OptionDef\00", align 1
@src_file.47 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.48 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.49 = private unnamed_addr constant [10 x i8] c"OptionDef\00", align 1
@src_file.50 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.51 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.52 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.53 = private unnamed_addr constant [10 x i8] c"OptionDef\00", align 1
@src_file.54 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.55 = private unnamed_addr constant [16 x i8] c"is_option_match\00", align 1
@mu_file.56 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.57 = private unnamed_addr constant [12 x i8] c"merge_flags\00", align 1
@mu_file.58 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.59 = private unnamed_addr constant [14 x i8] c"merge_options\00", align 1
@mu_file.60 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.61 = private unnamed_addr constant [16 x i8] c"merge_arg_lists\00", align 1
@mu_file.62 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.63 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.64 = private unnamed_addr constant [10 x i8] c"OptionDef\00", align 1
@src_file.65 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.66 = private unnamed_addr constant [12 x i8] c"default_val\00", align 1
@sty_name.67 = private unnamed_addr constant [10 x i8] c"OptionDef\00", align 1
@src_file.68 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.69 = private unnamed_addr constant [21 x i8] c"init_option_defaults\00", align 1
@mu_file.70 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.71 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.72 = private unnamed_addr constant [13 x i8] c"ParsedOption\00", align 1
@src_file.73 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.74 = private unnamed_addr constant [11 x i8] c"set_option\00", align 1
@mu_file.75 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.76 = private unnamed_addr constant [7 x i8] c"arg_at\00", align 1
@mu_file.77 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.78 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.79 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.80 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.81 = private unnamed_addr constant [13 x i8] c"find_command\00", align 1
@mu_file.82 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.83 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.84 = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.85 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.86 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.87 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.88 = private unnamed_addr constant [17 x i8] c"unknown option: \00", align 1
@.str.89 = private unnamed_addr constant [15 x i8] c"unknown flag: \00", align 1
@fld_name.90 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.91 = private unnamed_addr constant [7 x i8] c"ArgDef\00", align 1
@src_file.92 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.93 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.94 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.95 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.96 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.97 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.98 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.99 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.100 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.101 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.102 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.103 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.104 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.105 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.106 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.107 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.108 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.109 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.110 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.111 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.112 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.113 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.114 = private unnamed_addr constant [11 x i8] c"CommandDef\00", align 1
@src_file.115 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.116 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.117 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.118 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.119 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.120 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.121 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.122 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.123 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.124 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.125 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.126 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.127 = private unnamed_addr constant [4 x i8] c"Cli\00", align 1
@src_file.128 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.129 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.130 = private unnamed_addr constant [12 x i8] c"ParseResult\00", align 1
@src_file.131 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.132 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.133 = private unnamed_addr constant [11 x i8] c"ParsedFlag\00", align 1
@src_file.134 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.135 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.136 = private unnamed_addr constant [11 x i8] c"ParsedFlag\00", align 1
@src_file.137 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.138 = private unnamed_addr constant [16 x i8] c"has_parsed_flag\00", align 1
@mu_file.139 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.140 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.141 = private unnamed_addr constant [12 x i8] c"ParseResult\00", align 1
@src_file.142 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.143 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.144 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.145 = private unnamed_addr constant [13 x i8] c"ParsedOption\00", align 1
@src_file.146 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.147 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.148 = private unnamed_addr constant [13 x i8] c"ParsedOption\00", align 1
@src_file.149 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.150 = private unnamed_addr constant [18 x i8] c"get_parsed_option\00", align 1
@mu_file.151 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.152 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.153 = private unnamed_addr constant [12 x i8] c"ParseResult\00", align 1
@src_file.154 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.155 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.156 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.157 = private unnamed_addr constant [10 x i8] c"ParsedArg\00", align 1
@src_file.158 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@fld_name.159 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.160 = private unnamed_addr constant [10 x i8] c"ParsedArg\00", align 1
@src_file.161 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.match_fn.162 = private unnamed_addr constant [15 x i8] c"get_parsed_arg\00", align 1
@mu_file.163 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.164 = private unnamed_addr constant [6 x i8] c"forge\00", align 1
@.str.165 = private unnamed_addr constant [15 x i8] c"Forge compiler\00", align 1
@.str.166 = private unnamed_addr constant [6 x i8] c"0.1.0\00", align 1
@.str.167 = private unnamed_addr constant [8 x i8] c"compile\00", align 1
@.str.168 = private unnamed_addr constant [21 x i8] c"Compile a Forge file\00", align 1
@.str.169 = private unnamed_addr constant [8 x i8] c"compile\00", align 1
@.str.170 = private unnamed_addr constant [11 x i8] c"--coverage\00", align 1
@.str.171 = private unnamed_addr constant [3 x i8] c"-c\00", align 1
@.str.172 = private unnamed_addr constant [16 x i8] c"Enable coverage\00", align 1
@.str.173 = private unnamed_addr constant [8 x i8] c"compile\00", align 1
@.str.174 = private unnamed_addr constant [13 x i8] c"--stop-after\00", align 1
@.str.175 = private unnamed_addr constant [3 x i8] c"-s\00", align 1
@.str.176 = private unnamed_addr constant [17 x i8] c"Stop after phase\00", align 1
@.str.177 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.178 = private unnamed_addr constant [8 x i8] c"compile\00", align 1
@.str.179 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@.str.180 = private unnamed_addr constant [12 x i8] c"Source file\00", align 1
@.str.181 = private unnamed_addr constant [9 x i8] c"command=\00", align 1
@fld_name.182 = private unnamed_addr constant [8 x i8] c"command\00", align 1
@sty_name.183 = private unnamed_addr constant [12 x i8] c"ParseResult\00", align 1
@src_file.184 = private unnamed_addr constant [112 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/packages/std-cli/tests/cli_test.fg\00", align 1
@.str.185 = private unnamed_addr constant [15 x i8] c"has coverage: \00", align 1
@.str.186 = private unnamed_addr constant [9 x i8] c"coverage\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.187 = private unnamed_addr constant [6 x i8] c"file=\00", align 1
@.str.188 = private unnamed_addr constant [5 x i8] c"file\00", align 1
@.str.189 = private unnamed_addr constant [12 x i8] c"stop-after=\00", align 1
@.str.190 = private unnamed_addr constant [11 x i8] c"stop-after\00", align 1

declare i32 @puts(ptr)

declare void @forge_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @forge_rc_alloc(i64)

declare void @forge_rc_retain(ptr)

declare void @forge_rc_release(ptr)

declare i64 @forge_rc_should_free(ptr)

declare void @forge_rc_free(ptr)

declare void @forge_rc_suspect(ptr)

declare void @forge_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare void @exit(i32)

declare void @forge_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @forge_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @forge_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @forge_array_new()

declare void @forge_array_push(ptr, i64)

declare i64 @forge_array_get(ptr, i64)

declare i64 @forge_array_len(ptr)

declare void @forge_array_set(ptr, i64, i64)

declare i64 @forge_array_pop(ptr)

declare ptr @forge_array_slice(ptr, i64, i64)

declare i64 @forge_closure_get_fn(i64)

declare i64 @forge_closure_num_captures(i64)

declare i64 @forge_closure_get_capture(ptr, i64)

declare i64 @forge_closure_call_0(i64)

declare i64 @forge_closure_call_1(i64, i64)

declare i64 @forge_closure_call_2(i64, i64, i64)

declare i64 @forge_closure_call_3(i64, i64, i64, i64)

declare i64 @forge_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @forge_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @forge_array_map(ptr, i64)

declare ptr @forge_array_filter(ptr, i64)

declare void @forge_array_foreach(ptr, i64)

declare i64 @forge_array_reduce(ptr, i64, i64)

declare i64 @forge_array_contains(ptr, i64)

declare i64 @forge_array_index_of(ptr, i64)

declare ptr @forge_array_reverse(ptr)

declare i64 @forge_str_contains(ptr, ptr)

declare i64 @forge_str_starts_with(ptr, ptr)

declare i64 @forge_str_ends_with(ptr, ptr)

declare i64 @forge_str_index_of(ptr, ptr)

declare ptr @forge_str_split(ptr, ptr)

declare ptr @forge_str_replace(ptr, ptr, ptr)

declare ptr @forge_str_trim(ptr)

declare ptr @forge_str_to_upper(ptr)

declare ptr @forge_str_to_lower(ptr)

declare ptr @forge_str_join(ptr, ptr)

declare ptr @forge_str_char_at(ptr, i64)

declare ptr @forge_str_substring(ptr, i64, i64)

declare ptr @forge_str_repeat(ptr, i64)

declare ptr @forge_str_reverse(ptr)

declare ptr @forge_map_new_cstr()

declare void @forge_map_set_cstr(ptr, ptr, i64)

declare i64 @forge_map_get_cstr(ptr, ptr)

declare i64 @forge_map_has_cstr(ptr, ptr)

declare i64 @forge_map_len_cstr(ptr)

declare ptr @forge_map_keys_cstr(ptr)

declare ptr @forge_map_values_cstr(ptr)

declare i64 @forge_map_remove_cstr(ptr, ptr)

declare ptr @forge_file_read(ptr)

declare i64 @forge_file_write(ptr, ptr)

declare i64 @forge_file_exists(ptr)

declare ptr @forge_intmap_new()

declare void @forge_intmap_set(ptr, i64, i64)

declare i64 @forge_intmap_get(ptr, i64)

declare i64 @forge_intmap_has(ptr, i64)

declare i64 @forge_float_parse(ptr)

declare i64 @forge_float_to_string(i64)

declare ptr @forge_format_float(i64, ptr)

declare ptr @forge_format_int(i64, ptr)

declare void @forge_ptr_store_byte(ptr, i64, i64)

declare i64 @forge_string_from_ptr(ptr, i64)

declare i64 @forge_trait_object_new(ptr, i64)

declare i64 @forge_trait_object_value(ptr)

declare ptr @forge_trait_object_vtable(ptr)

declare i64 @forge_datetime_now()

declare i64 @forge_datetime_format(ptr, i64)

declare i64 @forge_datetime_year(ptr)

declare i64 @forge_datetime_month(ptr)

declare i64 @forge_datetime_day(ptr)

declare i64 @forge_datetime_hour(ptr)

declare i64 @forge_datetime_minute(ptr)

declare i64 @forge_datetime_second(ptr)

declare ptr @forge_json_stringify_int(ptr)

declare ptr @forge_json_stringify_string(ptr)

declare ptr @forge_json_stringify_bool(ptr)

declare i64 @forge_json_get_int(ptr, i64)

declare i64 @forge_json_get_string(ptr, i64)

declare i64 @forge_json_get_bool(ptr, i64)

declare i64 @forge_semver_major(ptr)

declare i64 @forge_semver_minor(ptr)

declare i64 @forge_semver_patch(ptr)

declare i64 @forge_semver_compare(ptr, i64)

declare i64 @forge_validate_not_null(ptr, i64)

declare i64 @forge_validate_positive(ptr, i64)

declare i64 @forge_validate_not_empty(ptr, i64)

declare i64 @forge_toml_get_string(ptr, i64)

declare i64 @forge_toml_get_int(ptr, i64)

declare i64 @forge_toml_get_bool(ptr, i64)

declare i64 @forge_toml_get_section_string(ptr, i64, i64)

declare i64 @forge_toml_has_section(ptr, i64)

declare i64 @forge_spawn(ptr)

declare i64 @forge_task_await(ptr)

declare i32 @forge_thread_join(ptr)

declare void @forge_yield()

declare void @forge_scheduler_run()

declare ptr @forge_task_group_new()

declare void @forge_task_group_add(ptr, ptr)

declare void @forge_task_group_await_all(ptr)

declare ptr @forge_channel_new()

declare void @forge_channel_send(ptr, i64)

declare i64 @forge_channel_recv(ptr)

declare i32 @forge_channel_close(ptr)

declare i32 @forge_parallel_run(ptr)

declare i64 @forge_select(ptr, i64)

declare i64 @forge_select_index(ptr)

declare i64 @forge_select_value(ptr)

declare i32 @forge_test_start_spec(ptr)

declare i32 @forge_test_end_spec(ptr)

declare i32 @forge_test_start_given(ptr)

declare i32 @forge_test_end_given(ptr)

declare i64 @forge_test_run_then(ptr, i64)

declare i32 @forge_test_skip(ptr)

declare i32 @forge_test_todo(ptr)

declare i32 @forge_test_summary()

declare ptr @forge_arena_new()

declare ptr @forge_arena_alloc(ptr, i64)

declare void @forge_arena_destroy(ptr)

declare void @forge_match_unreachable(ptr, i64, ptr, i64)

declare i32 @forge_llvm_is_ptr_value(ptr)

declare ptr @forge_llvm_typeof(ptr)

declare ptr @forge_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @forge_llvm_is_void_value(ptr)

declare void @forge_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @forge_llvm_verify_function(ptr)

declare i64 @forge_llvm_type_kind(ptr)

declare i64 @forge_llvm_int_type_width(ptr)

declare ptr @forge_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @forge_test_roughly(double, double, double)

declare i64 @forge_selfhost_argc()

declare ptr @forge_selfhost_get_arg_cstr(i64)

declare i64 @forge_process_exit(i64)

define ptr @cli_new(ptr %0, ptr %1, ptr %2) {
entry:
  %version = alloca ptr, align 8
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  store ptr %1, ptr %description, align 8
  store ptr %2, ptr %version, align 8
  %3 = call ptr @forge_rc_alloc(i64 56)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %description2 = load ptr, ptr %description, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 1
  store ptr %description2, ptr %fld_ptr3, align 8
  %version4 = load ptr, ptr %version, align 8
  %fld_ptr5 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 2
  store ptr %version4, ptr %fld_ptr5, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %4, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CommandList, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %4 to i64
  %fld_ptr6 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 3
  %cast7 = inttoptr i64 %cast to ptr
  store ptr %cast7, ptr %fld_ptr6, align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %FlagList, ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %FlagList, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr9, align 8
  %cast10 = ptrtoint ptr %5 to i64
  %fld_ptr11 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 4
  %cast12 = inttoptr i64 %cast10 to ptr
  store ptr %cast12, ptr %fld_ptr11, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %OptionList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %OptionList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr14, align 8
  %cast15 = ptrtoint ptr %6 to i64
  %fld_ptr16 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 5
  %cast17 = inttoptr i64 %cast15 to ptr
  store ptr %cast17, ptr %fld_ptr16, align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %ArgList, ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %ArgList, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr19, align 8
  %cast20 = ptrtoint ptr %7 to i64
  %fld_ptr21 = getelementptr inbounds nuw %Cli, ptr %3, i32 0, i32 6
  %cast22 = inttoptr i64 %cast20 to ptr
  store ptr %cast22, ptr %fld_ptr21, align 8
  %cast23 = ptrtoint ptr %3 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  ret ptr %cast24
}

define ptr @cli_add_command(ptr %0, ptr %1, ptr %2) {
entry:
  %cmd = alloca ptr, align 8
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %description, align 8
  %3 = call ptr @forge_rc_alloc(i64 40)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %CommandDef, ptr %3, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %description2 = load ptr, ptr %description, align 8
  %fld_ptr3 = getelementptr inbounds nuw %CommandDef, ptr %3, i32 0, i32 1
  store ptr %description2, ptr %fld_ptr3, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %FlagList, ptr %4, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %FlagList, ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %4 to i64
  %fld_ptr4 = getelementptr inbounds nuw %CommandDef, ptr %3, i32 0, i32 2
  %cast5 = inttoptr i64 %cast to ptr
  store ptr %cast5, ptr %fld_ptr4, align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %OptionList, ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %OptionList, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %5 to i64
  %fld_ptr9 = getelementptr inbounds nuw %CommandDef, ptr %3, i32 0, i32 3
  %cast10 = inttoptr i64 %cast8 to ptr
  store ptr %cast10, ptr %fld_ptr9, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %ArgList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %ArgList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast13 = ptrtoint ptr %6 to i64
  %fld_ptr14 = getelementptr inbounds nuw %CommandDef, ptr %3, i32 0, i32 4
  %cast15 = inttoptr i64 %cast13 to ptr
  store ptr %cast15, ptr %fld_ptr14, align 8
  %cast16 = ptrtoint ptr %3 to i64
  %cast17 = inttoptr i64 %cast16 to ptr
  store ptr %cast17, ptr %cmd, align 8
  %cli18 = load ptr, ptr %cli, align 8
  %7 = call ptr @forge_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src19 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 1
  %with_cp_val20 = load ptr, ptr %with_cp_src19, align 8
  %with_cp_dst21 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 1
  store ptr %with_cp_val20, ptr %with_cp_dst21, align 8
  %with_cp_src22 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 2
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 2
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 3
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 3
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 4
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 4
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 5
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 5
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %with_cp_src34 = getelementptr inbounds nuw %Cli, ptr %cli18, i32 0, i32 6
  %with_cp_val35 = load ptr, ptr %with_cp_src34, align 8
  %with_cp_dst36 = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 6
  store ptr %with_cp_val35, ptr %with_cp_dst36, align 8
  %8 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %CommandList, ptr %8, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %CommandList, ptr %8, i32 0, i32 1
  %9 = call ptr @forge_rc_alloc(i64 16)
  store ptr %9, ptr %pay_ptr38, align 8
  %cmd39 = load ptr, ptr %cmd, align 8
  %slot_base = ptrtoint ptr %9 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %cmd39, ptr %slot, align 8
  %cli40 = load ptr, ptr %cli, align 8
  %cast41 = ptrtoint ptr %cli40 to i64
  %null_chk = icmp eq i64 %cast41, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name, i64 8, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 111, i64 100)
  %commands_ptr = getelementptr inbounds nuw %Cli, ptr %cli40, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %slot_base42 = ptrtoint ptr %9 to i64
  %slot_addr43 = add i64 %slot_base42, 8
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store ptr %commands, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %with_ovr = getelementptr inbounds nuw %Cli, ptr %7, i32 0, i32 3
  store i64 %cast45, ptr %with_ovr, align 8
  %cast46 = ptrtoint ptr %7 to i64
  %cast47 = inttoptr i64 %cast46 to ptr
  ret ptr %cast47
}

define ptr @cli_command_add_flag(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4) {
entry:
  %description = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %short, align 8
  store ptr %4, ptr %description, align 8
  %cli1 = load ptr, ptr %cli, align 8
  %5 = call ptr @forge_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.1, i64 8, ptr @sty_name.2, i64 3, i64 %null_ext, ptr @src_file.3, i64 111, i64 104)
  %commands_ptr = getelementptr inbounds nuw %Cli, ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %short23 = load ptr, ptr %short, align 8
  %description24 = load ptr, ptr %description, align 8
  %6 = call ptr @update_command_flags(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %short23, ptr %description24)
  %with_ovr = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 3
  store ptr %6, ptr %with_ovr, align 8
  %cast25 = ptrtoint ptr %5 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  ret ptr %cast26
}

define ptr @update_command_flags(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4) {
entry:
  %updated = alloca ptr, align 8
  %f = alloca ptr, align 8
  %sif_result = alloca i64, align 8
  %next9 = alloca ptr, align 8
  %cmd6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %desc = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cmds = alloca ptr, align 8
  store ptr %0, ptr %cmds, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %short, align 8
  store ptr %4, ptr %desc, align 8
  %cmds1 = load ptr, ptr %cmds, align 8
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast73 = inttoptr i64 %match_val to ptr
  ret ptr %cast73

march_arm:                                        ; preds = %entry
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %CommandList, ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %CommandList, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @forge_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 10, i64 %null_ext, ptr @src_file.6, i64 111, i64 112)
  %name_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd10, i32 0, i32 0
  %name12 = load ptr, ptr %name_ptr, align 8
  %cmd_name13 = load ptr, ptr %cmd_name, align 8
  %6 = call i32 @strcmp(ptr %name12, ptr %cmd_name13)
  %widen = sext i32 %6 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 108)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %7 = call ptr @forge_rc_alloc(i64 24)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %FlagDef, ptr %7, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %short15 = load ptr, ptr %short, align 8
  %fld_ptr16 = getelementptr inbounds nuw %FlagDef, ptr %7, i32 0, i32 1
  store ptr %short15, ptr %fld_ptr16, align 8
  %desc17 = load ptr, ptr %desc, align 8
  %fld_ptr18 = getelementptr inbounds nuw %FlagDef, ptr %7, i32 0, i32 2
  store ptr %desc17, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %7 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %f, align 8
  %cmd21 = load ptr, ptr %cmd6, align 8
  %8 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src22 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 1
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 1
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 2
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 2
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 3
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 3
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 4
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 4
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr34 = getelementptr inbounds nuw %FlagList, ptr %9, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr34, align 8
  %pay_ptr35 = getelementptr inbounds nuw %FlagList, ptr %9, i32 0, i32 1
  %10 = call ptr @forge_rc_alloc(i64 16)
  store ptr %10, ptr %pay_ptr35, align 8
  %f36 = load ptr, ptr %f, align 8
  %slot_base = ptrtoint ptr %10 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %f36, ptr %slot, align 8
  %cmd37 = load ptr, ptr %cmd6, align 8
  %cast38 = ptrtoint ptr %cmd37 to i64
  %null_chk39 = icmp eq i64 %cast38, 0
  %null_ext40 = zext i1 %null_chk39 to i64
  call void @forge_null_deref_trap(ptr @fld_name.7, i64 5, ptr @sty_name.8, i64 10, i64 %null_ext40, ptr @src_file.9, i64 111, i64 114)
  %flags_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd37, i32 0, i32 2
  %flags = load ptr, ptr %flags_ptr, align 8
  %slot_base41 = ptrtoint ptr %10 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr %flags, ptr %slot43, align 8
  %cast44 = ptrtoint ptr %9 to i64
  %with_ovr = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 2
  store i64 %cast44, ptr %with_ovr, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %updated, align 8
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %CommandList, ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %CommandList, ptr %11, i32 0, i32 1
  %12 = call ptr @forge_rc_alloc(i64 16)
  store ptr %12, ptr %pay_ptr48, align 8
  %updated49 = load ptr, ptr %updated, align 8
  %slot_base50 = ptrtoint ptr %12 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  store ptr %updated49, ptr %slot52, align 8
  %next53 = load ptr, ptr %next9, align 8
  %slot_base54 = ptrtoint ptr %12 to i64
  %slot_addr55 = add i64 %slot_base54, 8
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  store ptr %next53, ptr %slot56, align 8
  %cast57 = ptrtoint ptr %11 to i64
  store i64 %cast57, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm3
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr58 = getelementptr inbounds nuw %CommandList, ptr %13, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr58, align 8
  %pay_ptr59 = getelementptr inbounds nuw %CommandList, ptr %13, i32 0, i32 1
  %14 = call ptr @forge_rc_alloc(i64 16)
  store ptr %14, ptr %pay_ptr59, align 8
  %cmd60 = load ptr, ptr %cmd6, align 8
  %slot_base61 = ptrtoint ptr %14 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  store ptr %cmd60, ptr %slot63, align 8
  %next64 = load ptr, ptr %next9, align 8
  %cmd_name65 = load ptr, ptr %cmd_name, align 8
  %name66 = load ptr, ptr %name, align 8
  %short67 = load ptr, ptr %short, align 8
  %desc68 = load ptr, ptr %desc, align 8
  %15 = call ptr @update_command_flags(ptr %next64, ptr %cmd_name65, ptr %name66, ptr %short67, ptr %desc68)
  %slot_base69 = ptrtoint ptr %14 to i64
  %slot_addr70 = add i64 %slot_base69, 8
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  store ptr %15, ptr %slot71, align 8
  %cast72 = ptrtoint ptr %13 to i64
  store i64 %cast72, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @cli_command_add_option(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4, ptr %5) {
entry:
  %default_val = alloca ptr, align 8
  %description = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %short, align 8
  store ptr %4, ptr %description, align 8
  store ptr %5, ptr %default_val, align 8
  %cli1 = load ptr, ptr %cli, align 8
  %6 = call ptr @forge_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.10, i64 8, ptr @sty_name.11, i64 3, i64 %null_ext, ptr @src_file.12, i64 111, i64 124)
  %commands_ptr = getelementptr inbounds nuw %Cli, ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %short23 = load ptr, ptr %short, align 8
  %description24 = load ptr, ptr %description, align 8
  %default_val25 = load ptr, ptr %default_val, align 8
  %7 = call ptr @update_command_options(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %short23, ptr %description24, ptr %default_val25)
  %with_ovr = getelementptr inbounds nuw %Cli, ptr %6, i32 0, i32 3
  store ptr %7, ptr %with_ovr, align 8
  %cast26 = ptrtoint ptr %6 to i64
  %cast27 = inttoptr i64 %cast26 to ptr
  ret ptr %cast27
}

define ptr @update_command_options(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4, ptr %5) {
entry:
  %updated = alloca ptr, align 8
  %o = alloca ptr, align 8
  %sif_result = alloca i64, align 8
  %next9 = alloca ptr, align 8
  %cmd6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %default_val = alloca ptr, align 8
  %desc = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cmds = alloca ptr, align 8
  store ptr %0, ptr %cmds, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %short, align 8
  store ptr %4, ptr %desc, align 8
  store ptr %5, ptr %default_val, align 8
  %cmds1 = load ptr, ptr %cmds, align 8
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast76 = inttoptr i64 %match_val to ptr
  ret ptr %cast76

march_arm:                                        ; preds = %entry
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %CommandList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %CommandList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @forge_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.13, i64 4, ptr @sty_name.14, i64 10, i64 %null_ext, ptr @src_file.15, i64 111, i64 132)
  %name_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd10, i32 0, i32 0
  %name12 = load ptr, ptr %name_ptr, align 8
  %cmd_name13 = load ptr, ptr %cmd_name, align 8
  %7 = call i32 @strcmp(ptr %name12, ptr %cmd_name13)
  %widen = sext i32 %7 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.19, i64 %tag, ptr @mu_file.20, i64 128)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %8 = call ptr @forge_rc_alloc(i64 32)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %OptionDef, ptr %8, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %short15 = load ptr, ptr %short, align 8
  %fld_ptr16 = getelementptr inbounds nuw %OptionDef, ptr %8, i32 0, i32 1
  store ptr %short15, ptr %fld_ptr16, align 8
  %desc17 = load ptr, ptr %desc, align 8
  %fld_ptr18 = getelementptr inbounds nuw %OptionDef, ptr %8, i32 0, i32 2
  store ptr %desc17, ptr %fld_ptr18, align 8
  %default_val19 = load ptr, ptr %default_val, align 8
  %fld_ptr20 = getelementptr inbounds nuw %OptionDef, ptr %8, i32 0, i32 3
  store ptr %default_val19, ptr %fld_ptr20, align 8
  %cast21 = ptrtoint ptr %8 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  store ptr %cast22, ptr %o, align 8
  %cmd23 = load ptr, ptr %cmd6, align 8
  %9 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %CommandDef, ptr %cmd23, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src24 = getelementptr inbounds nuw %CommandDef, ptr %cmd23, i32 0, i32 1
  %with_cp_val25 = load ptr, ptr %with_cp_src24, align 8
  %with_cp_dst26 = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 1
  store ptr %with_cp_val25, ptr %with_cp_dst26, align 8
  %with_cp_src27 = getelementptr inbounds nuw %CommandDef, ptr %cmd23, i32 0, i32 2
  %with_cp_val28 = load ptr, ptr %with_cp_src27, align 8
  %with_cp_dst29 = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 2
  store ptr %with_cp_val28, ptr %with_cp_dst29, align 8
  %with_cp_src30 = getelementptr inbounds nuw %CommandDef, ptr %cmd23, i32 0, i32 3
  %with_cp_val31 = load ptr, ptr %with_cp_src30, align 8
  %with_cp_dst32 = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 3
  store ptr %with_cp_val31, ptr %with_cp_dst32, align 8
  %with_cp_src33 = getelementptr inbounds nuw %CommandDef, ptr %cmd23, i32 0, i32 4
  %with_cp_val34 = load ptr, ptr %with_cp_src33, align 8
  %with_cp_dst35 = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 4
  store ptr %with_cp_val34, ptr %with_cp_dst35, align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %OptionList, ptr %10, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %OptionList, ptr %10, i32 0, i32 1
  %11 = call ptr @forge_rc_alloc(i64 16)
  store ptr %11, ptr %pay_ptr37, align 8
  %o38 = load ptr, ptr %o, align 8
  %slot_base = ptrtoint ptr %11 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %o38, ptr %slot, align 8
  %cmd39 = load ptr, ptr %cmd6, align 8
  %cast40 = ptrtoint ptr %cmd39 to i64
  %null_chk41 = icmp eq i64 %cast40, 0
  %null_ext42 = zext i1 %null_chk41 to i64
  call void @forge_null_deref_trap(ptr @fld_name.16, i64 7, ptr @sty_name.17, i64 10, i64 %null_ext42, ptr @src_file.18, i64 111, i64 134)
  %options_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd39, i32 0, i32 3
  %options = load ptr, ptr %options_ptr, align 8
  %slot_base43 = ptrtoint ptr %11 to i64
  %slot_addr44 = add i64 %slot_base43, 8
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  store ptr %options, ptr %slot45, align 8
  %cast46 = ptrtoint ptr %10 to i64
  %with_ovr = getelementptr inbounds nuw %CommandDef, ptr %9, i32 0, i32 3
  store i64 %cast46, ptr %with_ovr, align 8
  %cast47 = ptrtoint ptr %9 to i64
  %cast48 = inttoptr i64 %cast47 to ptr
  store ptr %cast48, ptr %updated, align 8
  %12 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr49 = getelementptr inbounds nuw %CommandList, ptr %12, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr49, align 8
  %pay_ptr50 = getelementptr inbounds nuw %CommandList, ptr %12, i32 0, i32 1
  %13 = call ptr @forge_rc_alloc(i64 16)
  store ptr %13, ptr %pay_ptr50, align 8
  %updated51 = load ptr, ptr %updated, align 8
  %slot_base52 = ptrtoint ptr %13 to i64
  %slot_addr53 = add i64 %slot_base52, 0
  %slot54 = inttoptr i64 %slot_addr53 to ptr
  store ptr %updated51, ptr %slot54, align 8
  %next55 = load ptr, ptr %next9, align 8
  %slot_base56 = ptrtoint ptr %13 to i64
  %slot_addr57 = add i64 %slot_base56, 8
  %slot58 = inttoptr i64 %slot_addr57 to ptr
  store ptr %next55, ptr %slot58, align 8
  %cast59 = ptrtoint ptr %12 to i64
  store i64 %cast59, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm3
  %14 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr60 = getelementptr inbounds nuw %CommandList, ptr %14, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr60, align 8
  %pay_ptr61 = getelementptr inbounds nuw %CommandList, ptr %14, i32 0, i32 1
  %15 = call ptr @forge_rc_alloc(i64 16)
  store ptr %15, ptr %pay_ptr61, align 8
  %cmd62 = load ptr, ptr %cmd6, align 8
  %slot_base63 = ptrtoint ptr %15 to i64
  %slot_addr64 = add i64 %slot_base63, 0
  %slot65 = inttoptr i64 %slot_addr64 to ptr
  store ptr %cmd62, ptr %slot65, align 8
  %next66 = load ptr, ptr %next9, align 8
  %cmd_name67 = load ptr, ptr %cmd_name, align 8
  %name68 = load ptr, ptr %name, align 8
  %short69 = load ptr, ptr %short, align 8
  %desc70 = load ptr, ptr %desc, align 8
  %default_val71 = load ptr, ptr %default_val, align 8
  %16 = call ptr @update_command_options(ptr %next66, ptr %cmd_name67, ptr %name68, ptr %short69, ptr %desc70, ptr %default_val71)
  %slot_base72 = ptrtoint ptr %15 to i64
  %slot_addr73 = add i64 %slot_base72, 8
  %slot74 = inttoptr i64 %slot_addr73 to ptr
  store ptr %16, ptr %slot74, align 8
  %cast75 = ptrtoint ptr %14 to i64
  store i64 %cast75, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @cli_command_add_arg(ptr %0, ptr %1, ptr %2, ptr %3, i1 %4) {
entry:
  %required = alloca i1, align 1
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %description, align 8
  store i1 %4, ptr %required, align 8
  %cli1 = load ptr, ptr %cli, align 8
  %5 = call ptr @forge_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %Cli, ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.21, i64 8, ptr @sty_name.22, i64 3, i64 %null_ext, ptr @src_file.23, i64 111, i64 144)
  %commands_ptr = getelementptr inbounds nuw %Cli, ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %description23 = load ptr, ptr %description, align 8
  %required24 = load i1, ptr %required, align 8
  %6 = call ptr @update_command_args(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %description23, i1 %required24)
  %with_ovr = getelementptr inbounds nuw %Cli, ptr %5, i32 0, i32 3
  store ptr %6, ptr %with_ovr, align 8
  %cast25 = ptrtoint ptr %5 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  ret ptr %cast26
}

define ptr @update_command_args(ptr %0, ptr %1, ptr %2, ptr %3, i1 %4) {
entry:
  %updated = alloca ptr, align 8
  %a = alloca ptr, align 8
  %sif_result = alloca i64, align 8
  %next9 = alloca ptr, align 8
  %cmd6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %required = alloca i1, align 1
  %desc = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  %cmds = alloca ptr, align 8
  store ptr %0, ptr %cmds, align 8
  store ptr %1, ptr %cmd_name, align 8
  store ptr %2, ptr %name, align 8
  store ptr %3, ptr %desc, align 8
  store i1 %4, ptr %required, align 8
  %cmds1 = load ptr, ptr %cmds, align 8
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast73 = inttoptr i64 %match_val to ptr
  ret ptr %cast73

march_arm:                                        ; preds = %entry
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %CommandList, ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %CommandList, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @forge_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.24, i64 4, ptr @sty_name.25, i64 10, i64 %null_ext, ptr @src_file.26, i64 111, i64 152)
  %name_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd10, i32 0, i32 0
  %name12 = load ptr, ptr %name_ptr, align 8
  %cmd_name13 = load ptr, ptr %cmd_name, align 8
  %6 = call i32 @strcmp(ptr %name12, ptr %cmd_name13)
  %widen = sext i32 %6 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.30, i64 %tag, ptr @mu_file.31, i64 148)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %7 = call ptr @forge_rc_alloc(i64 24)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %ArgDef, ptr %7, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %desc15 = load ptr, ptr %desc, align 8
  %fld_ptr16 = getelementptr inbounds nuw %ArgDef, ptr %7, i32 0, i32 1
  store ptr %desc15, ptr %fld_ptr16, align 8
  %required17 = load i1, ptr %required, align 8
  %fld_ptr18 = getelementptr inbounds nuw %ArgDef, ptr %7, i32 0, i32 2
  store i1 %required17, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %7 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %a, align 8
  %cmd21 = load ptr, ptr %cmd6, align 8
  %8 = call ptr @forge_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src22 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 1
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 1
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 2
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 2
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 3
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 3
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %CommandDef, ptr %cmd21, i32 0, i32 4
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 4
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %9 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr34 = getelementptr inbounds nuw %ArgList, ptr %9, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr34, align 8
  %pay_ptr35 = getelementptr inbounds nuw %ArgList, ptr %9, i32 0, i32 1
  %10 = call ptr @forge_rc_alloc(i64 16)
  store ptr %10, ptr %pay_ptr35, align 8
  %a36 = load ptr, ptr %a, align 8
  %slot_base = ptrtoint ptr %10 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %a36, ptr %slot, align 8
  %cmd37 = load ptr, ptr %cmd6, align 8
  %cast38 = ptrtoint ptr %cmd37 to i64
  %null_chk39 = icmp eq i64 %cast38, 0
  %null_ext40 = zext i1 %null_chk39 to i64
  call void @forge_null_deref_trap(ptr @fld_name.27, i64 4, ptr @sty_name.28, i64 10, i64 %null_ext40, ptr @src_file.29, i64 111, i64 154)
  %args_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd37, i32 0, i32 4
  %args = load ptr, ptr %args_ptr, align 8
  %slot_base41 = ptrtoint ptr %10 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr %args, ptr %slot43, align 8
  %cast44 = ptrtoint ptr %9 to i64
  %with_ovr = getelementptr inbounds nuw %CommandDef, ptr %8, i32 0, i32 4
  store i64 %cast44, ptr %with_ovr, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %updated, align 8
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %CommandList, ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %CommandList, ptr %11, i32 0, i32 1
  %12 = call ptr @forge_rc_alloc(i64 16)
  store ptr %12, ptr %pay_ptr48, align 8
  %updated49 = load ptr, ptr %updated, align 8
  %slot_base50 = ptrtoint ptr %12 to i64
  %slot_addr51 = add i64 %slot_base50, 0
  %slot52 = inttoptr i64 %slot_addr51 to ptr
  store ptr %updated49, ptr %slot52, align 8
  %next53 = load ptr, ptr %next9, align 8
  %slot_base54 = ptrtoint ptr %12 to i64
  %slot_addr55 = add i64 %slot_base54, 8
  %slot56 = inttoptr i64 %slot_addr55 to ptr
  store ptr %next53, ptr %slot56, align 8
  %cast57 = ptrtoint ptr %11 to i64
  store i64 %cast57, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm3
  %13 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr58 = getelementptr inbounds nuw %CommandList, ptr %13, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr58, align 8
  %pay_ptr59 = getelementptr inbounds nuw %CommandList, ptr %13, i32 0, i32 1
  %14 = call ptr @forge_rc_alloc(i64 16)
  store ptr %14, ptr %pay_ptr59, align 8
  %cmd60 = load ptr, ptr %cmd6, align 8
  %slot_base61 = ptrtoint ptr %14 to i64
  %slot_addr62 = add i64 %slot_base61, 0
  %slot63 = inttoptr i64 %slot_addr62 to ptr
  store ptr %cmd60, ptr %slot63, align 8
  %next64 = load ptr, ptr %next9, align 8
  %cmd_name65 = load ptr, ptr %cmd_name, align 8
  %name66 = load ptr, ptr %name, align 8
  %desc67 = load ptr, ptr %desc, align 8
  %required68 = load i1, ptr %required, align 8
  %15 = call ptr @update_command_args(ptr %next64, ptr %cmd_name65, ptr %name66, ptr %desc67, i1 %required68)
  %slot_base69 = ptrtoint ptr %14 to i64
  %slot_addr70 = add i64 %slot_base69, 8
  %slot71 = inttoptr i64 %slot_addr70 to ptr
  store ptr %15, ptr %slot71, align 8
  %cast72 = ptrtoint ptr %13 to i64
  store i64 %cast72, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @strip_dashes(ptr %0) {
entry:
  %sif_result13 = alloca i64, align 8
  %sif_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @forge_str_starts_with(ptr %s1, ptr @.str)
  %sif_cond = icmp ne i64 %1, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %s2 = load ptr, ptr %s, align 8
  %s3 = load ptr, ptr %s, align 8
  %2 = call i64 @strlen(ptr %s3)
  %sub_len = sub i64 %2, 2
  %sub_alloc = add i64 %sub_len, 1
  %3 = call ptr @forge_rc_alloc(i64 %sub_alloc)
  %cast = ptrtoint ptr %s2 to i64
  %sub_off_int = add i64 %cast, 2
  %cast4 = inttoptr i64 %sub_off_int to ptr
  %4 = call ptr @memcpy(ptr %3, ptr %cast4, i64 %sub_len)
  %cast5 = ptrtoint ptr %3 to i64
  %sub_nul_int = add i64 %cast5, %sub_len
  %cast6 = inttoptr i64 %sub_nul_int to ptr
  store i8 0, ptr %cast6, align 8
  %cast7 = ptrtoint ptr %3 to i64
  store i64 %cast7, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %s8 = load ptr, ptr %s, align 8
  %5 = call i64 @forge_str_starts_with(ptr %s8, ptr @.str.32)
  %sif_cond9 = icmp ne i64 %5, 0
  store i64 0, ptr %sif_result13, align 8
  br i1 %sif_cond9, label %sif_then10, label %sif_else11

sif_end:                                          ; preds = %sif_end12, %sif_then
  %sif_val27 = load i64, ptr %sif_result, align 8
  %cast28 = inttoptr i64 %sif_val27 to ptr
  ret ptr %cast28

sif_then10:                                       ; preds = %sif_else
  %s14 = load ptr, ptr %s, align 8
  %s15 = load ptr, ptr %s, align 8
  %6 = call i64 @strlen(ptr %s15)
  %sub_len16 = sub i64 %6, 1
  %sub_alloc17 = add i64 %sub_len16, 1
  %7 = call ptr @forge_rc_alloc(i64 %sub_alloc17)
  %cast18 = ptrtoint ptr %s14 to i64
  %sub_off_int19 = add i64 %cast18, 1
  %cast20 = inttoptr i64 %sub_off_int19 to ptr
  %8 = call ptr @memcpy(ptr %7, ptr %cast20, i64 %sub_len16)
  %cast21 = ptrtoint ptr %7 to i64
  %sub_nul_int22 = add i64 %cast21, %sub_len16
  %cast23 = inttoptr i64 %sub_nul_int22 to ptr
  store i8 0, ptr %cast23, align 8
  %cast24 = ptrtoint ptr %7 to i64
  store i64 %cast24, ptr %sif_result13, align 8
  br label %sif_end12

sif_else11:                                       ; preds = %sif_else
  %s25 = load ptr, ptr %s, align 8
  %cast26 = ptrtoint ptr %s25 to i64
  store i64 %cast26, ptr %sif_result13, align 8
  br label %sif_end12

sif_end12:                                        ; preds = %sif_else11, %sif_then10
  %sif_val = load i64, ptr %sif_result13, align 8
  store i64 %sif_val, ptr %sif_result, align 8
  br label %sif_end
}

define i1 @is_flag_match(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %f5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %arg = alloca ptr, align 8
  %flags = alloca ptr, align 8
  store ptr %0, ptr %flags, align 8
  store ptr %1, ptr %arg, align 8
  %flags1 = load ptr, ptr %flags, align 8
  %tag_ptr = getelementptr inbounds nuw %FlagList, ptr %flags1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast41 = trunc i64 %match_val to i1
  ret i1 %cast41

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %FlagList, ptr %flags1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @forge_rc_retain(ptr %f)
  store ptr %f, ptr %f5, align 8
  %pay_slot6 = getelementptr inbounds nuw %FlagList, ptr %flags1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %f9 = load ptr, ptr %f5, align 8
  %cast = ptrtoint ptr %f9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.33, i64 4, ptr @sty_name.34, i64 7, i64 %null_ext, ptr @src_file.35, i64 111, i64 174)
  %name_ptr = getelementptr inbounds nuw %FlagDef, ptr %f9, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %arg10 = load ptr, ptr %arg, align 8
  %2 = call i32 @strcmp(ptr %name, ptr %arg10)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %l_bool = icmp ne i64 %streq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.43, i64 %tag, ptr @mu_file.44, i64 170)
  unreachable

sc_rhs:                                           ; preds = %march_arm2
  %f11 = load ptr, ptr %f5, align 8
  %cast12 = ptrtoint ptr %f11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @forge_null_deref_trap(ptr @fld_name.36, i64 5, ptr @sty_name.37, i64 7, i64 %null_ext14, ptr @src_file.38, i64 111, i64 174)
  %short_ptr = getelementptr inbounds nuw %FlagDef, ptr %f11, i32 0, i32 1
  %short = load ptr, ptr %short_ptr, align 8
  %3 = call i32 @strcmp(ptr %short, ptr @.str.39)
  %widen15 = sext i32 %3 to i64
  %streq_cmp16 = icmp ne i64 %widen15, 0
  %streq_ext17 = zext i1 %streq_cmp16 to i64
  %l_bool18 = icmp ne i64 %streq_ext17, 0
  br i1 %l_bool18, label %sc_rhs19, label %sc_short20

sc_short:                                         ; preds = %march_arm2
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge35, %sc_short
  %sc_phi36 = phi i1 [ true, %sc_short ], [ %r_bool32, %sc_r_merge35 ]
  %sc_ext37 = zext i1 %sc_phi36 to i64
  %sif_cond = icmp ne i64 %sc_ext37, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_rhs19:                                         ; preds = %sc_rhs
  %f22 = load ptr, ptr %f5, align 8
  %cast23 = ptrtoint ptr %f22 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @forge_null_deref_trap(ptr @fld_name.40, i64 5, ptr @sty_name.41, i64 7, i64 %null_ext25, ptr @src_file.42, i64 111, i64 174)
  %short_ptr26 = getelementptr inbounds nuw %FlagDef, ptr %f22, i32 0, i32 1
  %short27 = load ptr, ptr %short_ptr26, align 8
  %arg28 = load ptr, ptr %arg, align 8
  %4 = call i32 @strcmp(ptr %short27, ptr %arg28)
  %widen29 = sext i32 %4 to i64
  %streq_cmp30 = icmp eq i64 %widen29, 0
  %streq_ext31 = zext i1 %streq_cmp30 to i64
  %r_bool = icmp ne i64 %streq_ext31, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short20:                                       ; preds = %sc_rhs
  br label %sc_merge21

sc_merge21:                                       ; preds = %sc_r_merge, %sc_short20
  %sc_phi = phi i1 [ false, %sc_short20 ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %r_bool32 = icmp ne i64 %sc_ext, 0
  br i1 %r_bool32, label %sc_r_true33, label %sc_r_false34

sc_r_true:                                        ; preds = %sc_rhs19
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs19
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge21

sc_r_true33:                                      ; preds = %sc_merge21
  br label %sc_r_merge35

sc_r_false34:                                     ; preds = %sc_merge21
  br label %sc_r_merge35

sc_r_merge35:                                     ; preds = %sc_r_false34, %sc_r_true33
  br label %sc_merge

sif_then:                                         ; preds = %sc_merge
  store i64 1, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
  %next38 = load ptr, ptr %next8, align 8
  %arg39 = load ptr, ptr %arg, align 8
  %5 = call i1 @is_flag_match(ptr %next38, ptr %arg39)
  %widen40 = zext i1 %5 to i64
  store i64 %widen40, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define i1 @is_option_match(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %o5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %arg = alloca ptr, align 8
  %options = alloca ptr, align 8
  store ptr %0, ptr %options, align 8
  store ptr %1, ptr %arg, align 8
  %options1 = load ptr, ptr %options, align 8
  %tag_ptr = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast41 = trunc i64 %match_val to i1
  ret i1 %cast41

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @forge_rc_retain(ptr %o)
  store ptr %o, ptr %o5, align 8
  %pay_slot6 = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %o9 = load ptr, ptr %o5, align 8
  %cast = ptrtoint ptr %o9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.45, i64 4, ptr @sty_name.46, i64 9, i64 %null_ext, ptr @src_file.47, i64 111, i64 185)
  %name_ptr = getelementptr inbounds nuw %OptionDef, ptr %o9, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %arg10 = load ptr, ptr %arg, align 8
  %2 = call i32 @strcmp(ptr %name, ptr %arg10)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %l_bool = icmp ne i64 %streq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.55, i64 %tag, ptr @mu_file.56, i64 181)
  unreachable

sc_rhs:                                           ; preds = %march_arm2
  %o11 = load ptr, ptr %o5, align 8
  %cast12 = ptrtoint ptr %o11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @forge_null_deref_trap(ptr @fld_name.48, i64 5, ptr @sty_name.49, i64 9, i64 %null_ext14, ptr @src_file.50, i64 111, i64 185)
  %short_ptr = getelementptr inbounds nuw %OptionDef, ptr %o11, i32 0, i32 1
  %short = load ptr, ptr %short_ptr, align 8
  %3 = call i32 @strcmp(ptr %short, ptr @.str.51)
  %widen15 = sext i32 %3 to i64
  %streq_cmp16 = icmp ne i64 %widen15, 0
  %streq_ext17 = zext i1 %streq_cmp16 to i64
  %l_bool18 = icmp ne i64 %streq_ext17, 0
  br i1 %l_bool18, label %sc_rhs19, label %sc_short20

sc_short:                                         ; preds = %march_arm2
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge35, %sc_short
  %sc_phi36 = phi i1 [ true, %sc_short ], [ %r_bool32, %sc_r_merge35 ]
  %sc_ext37 = zext i1 %sc_phi36 to i64
  %sif_cond = icmp ne i64 %sc_ext37, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sc_rhs19:                                         ; preds = %sc_rhs
  %o22 = load ptr, ptr %o5, align 8
  %cast23 = ptrtoint ptr %o22 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @forge_null_deref_trap(ptr @fld_name.52, i64 5, ptr @sty_name.53, i64 9, i64 %null_ext25, ptr @src_file.54, i64 111, i64 185)
  %short_ptr26 = getelementptr inbounds nuw %OptionDef, ptr %o22, i32 0, i32 1
  %short27 = load ptr, ptr %short_ptr26, align 8
  %arg28 = load ptr, ptr %arg, align 8
  %4 = call i32 @strcmp(ptr %short27, ptr %arg28)
  %widen29 = sext i32 %4 to i64
  %streq_cmp30 = icmp eq i64 %widen29, 0
  %streq_ext31 = zext i1 %streq_cmp30 to i64
  %r_bool = icmp ne i64 %streq_ext31, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short20:                                       ; preds = %sc_rhs
  br label %sc_merge21

sc_merge21:                                       ; preds = %sc_r_merge, %sc_short20
  %sc_phi = phi i1 [ false, %sc_short20 ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %r_bool32 = icmp ne i64 %sc_ext, 0
  br i1 %r_bool32, label %sc_r_true33, label %sc_r_false34

sc_r_true:                                        ; preds = %sc_rhs19
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs19
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge21

sc_r_true33:                                      ; preds = %sc_merge21
  br label %sc_r_merge35

sc_r_false34:                                     ; preds = %sc_merge21
  br label %sc_r_merge35

sc_r_merge35:                                     ; preds = %sc_r_false34, %sc_r_true33
  br label %sc_merge

sif_then:                                         ; preds = %sc_merge
  store i64 1, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %sc_merge
  %next38 = load ptr, ptr %next8, align 8
  %arg39 = load ptr, ptr %arg, align 8
  %5 = call i1 @is_option_match(ptr %next38, ptr %arg39)
  %widen40 = zext i1 %5 to i64
  store i64 %widen40, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @merge_flags(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %f6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %FlagList, ptr %a1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast18 = inttoptr i64 %match_val to ptr
  ret ptr %cast18

march_arm:                                        ; preds = %entry
  %b2 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %FlagList, ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @forge_rc_retain(ptr %f)
  store ptr %f, ptr %f6, align 8
  %pay_slot7 = getelementptr inbounds nuw %FlagList, ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %FlagList, ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %FlagList, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %f11 = load ptr, ptr %f6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %f11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @merge_flags(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.57, i64 %tag, ptr @mu_file.58, i64 192)
  unreachable
}

define ptr @merge_options(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %o6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %OptionList, ptr %a1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast18 = inttoptr i64 %match_val to ptr
  ret ptr %cast18

march_arm:                                        ; preds = %entry
  %b2 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %OptionList, ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @forge_rc_retain(ptr %o)
  store ptr %o, ptr %o6, align 8
  %pay_slot7 = getelementptr inbounds nuw %OptionList, ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %OptionList, ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %OptionList, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %o11 = load ptr, ptr %o6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %o11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @merge_options(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.59, i64 %tag, ptr @mu_file.60, i64 199)
  unreachable
}

define ptr @merge_arg_lists(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %arg6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %ArgList, ptr %a1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast18 = inttoptr i64 %match_val to ptr
  ret ptr %cast18

march_arm:                                        ; preds = %entry
  %b2 = load ptr, ptr %b, align 8
  %cast = ptrtoint ptr %b2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ArgList, ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %arg_slot_base = ptrtoint ptr %payload to i64
  %arg_slot_addr = add i64 %arg_slot_base, 0
  %arg_slot = inttoptr i64 %arg_slot_addr to ptr
  %arg = load ptr, ptr %arg_slot, align 8
  call void @forge_rc_retain(ptr %arg)
  store ptr %arg, ptr %arg6, align 8
  %pay_slot7 = getelementptr inbounds nuw %ArgList, ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %ArgList, ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %ArgList, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %arg11 = load ptr, ptr %arg6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %arg11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @merge_arg_lists(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.61, i64 %tag, ptr @mu_file.62, i64 206)
  unreachable
}

define ptr @init_option_defaults(ptr %0) {
entry:
  %next9 = alloca ptr, align 8
  %o6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %options = alloca ptr, align 8
  store ptr %0, ptr %options, align 8
  %options1 = load ptr, ptr %options, align 8
  %tag_ptr = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast26 = inttoptr i64 %match_val to ptr
  ret ptr %cast26

march_arm:                                        ; preds = %entry
  %1 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %ParsedOptionList, ptr %1, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @forge_rc_retain(ptr %o)
  store ptr %o, ptr %o6, align 8
  %pay_slot7 = getelementptr inbounds nuw %OptionList, ptr %options1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %ParsedOptionList, ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %ParsedOptionList, ptr %2, i32 0, i32 1
  %3 = call ptr @forge_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr11, align 8
  %4 = call ptr @forge_rc_alloc(i64 16)
  %o12 = load ptr, ptr %o6, align 8
  %cast13 = ptrtoint ptr %o12 to i64
  %null_chk = icmp eq i64 %cast13, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.63, i64 4, ptr @sty_name.64, i64 9, i64 %null_ext, ptr @src_file.65, i64 111, i64 217)
  %name_ptr = getelementptr inbounds nuw %OptionDef, ptr %o12, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %5 = call ptr @strip_dashes(ptr %name)
  %fld_ptr = getelementptr inbounds nuw %ParsedOption, ptr %4, i32 0, i32 0
  store ptr %5, ptr %fld_ptr, align 8
  %o14 = load ptr, ptr %o6, align 8
  %cast15 = ptrtoint ptr %o14 to i64
  %null_chk16 = icmp eq i64 %cast15, 0
  %null_ext17 = zext i1 %null_chk16 to i64
  call void @forge_null_deref_trap(ptr @fld_name.66, i64 11, ptr @sty_name.67, i64 9, i64 %null_ext17, ptr @src_file.68, i64 111, i64 217)
  %default_val_ptr = getelementptr inbounds nuw %OptionDef, ptr %o14, i32 0, i32 3
  %default_val = load ptr, ptr %default_val_ptr, align 8
  %fld_ptr18 = getelementptr inbounds nuw %ParsedOption, ptr %4, i32 0, i32 1
  store ptr %default_val, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %4 to i64
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %slot, align 8
  %next21 = load ptr, ptr %next9, align 8
  %6 = call ptr @init_option_defaults(ptr %next21)
  %slot_base22 = ptrtoint ptr %3 to i64
  %slot_addr23 = add i64 %slot_base22, 8
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store ptr %6, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %2 to i64
  store i64 %cast25, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.69, i64 %tag, ptr @mu_file.70, i64 213)
  unreachable
}

define ptr @set_option(ptr %0, ptr %1, ptr %2) {
entry:
  %sif_result = alloca i64, align 8
  %next21 = alloca ptr, align 8
  %po18 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %value = alloca ptr, align 8
  %name = alloca ptr, align 8
  %parsed = alloca ptr, align 8
  store ptr %0, ptr %parsed, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %value, align 8
  %parsed1 = load ptr, ptr %parsed, align 8
  %tag_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %parsed1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast55 = inttoptr i64 %match_val to ptr
  ret ptr %cast55

march_arm:                                        ; preds = %entry
  %3 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %ParsedOptionList, ptr %3, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %3, i32 0, i32 1
  %4 = call ptr @forge_rc_alloc(i64 16)
  store ptr %4, ptr %pay_ptr, align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %name3 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %ParsedOption, ptr %5, i32 0, i32 0
  store ptr %name3, ptr %fld_ptr, align 8
  %value4 = load ptr, ptr %value, align 8
  %fld_ptr5 = getelementptr inbounds nuw %ParsedOption, ptr %5, i32 0, i32 1
  store ptr %value4, ptr %fld_ptr5, align 8
  %cast = ptrtoint ptr %5 to i64
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %slot, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %ParsedOptionList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %ParsedOptionList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr8, align 8
  %cast9 = ptrtoint ptr %6 to i64
  %slot_base10 = ptrtoint ptr %4 to i64
  %slot_addr11 = add i64 %slot_base10, 8
  %slot12 = inttoptr i64 %slot_addr11 to ptr
  %cast13 = inttoptr i64 %cast9 to ptr
  store ptr %cast13, ptr %slot12, align 8
  %cast14 = ptrtoint ptr %3 to i64
  store i64 %cast14, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq17 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq17, label %march_arm15, label %march_next16

march_arm15:                                      ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ParsedOptionList, ptr %parsed1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %po_slot_base = ptrtoint ptr %payload to i64
  %po_slot_addr = add i64 %po_slot_base, 0
  %po_slot = inttoptr i64 %po_slot_addr to ptr
  %po = load ptr, ptr %po_slot, align 8
  call void @forge_rc_retain(ptr %po)
  store ptr %po, ptr %po18, align 8
  %pay_slot19 = getelementptr inbounds nuw %ParsedOptionList, ptr %parsed1, i32 0, i32 1
  %payload20 = load ptr, ptr %pay_slot19, align 8
  %next_slot_base = ptrtoint ptr %payload20 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next21, align 8
  %po22 = load ptr, ptr %po18, align 8
  %cast23 = ptrtoint ptr %po22 to i64
  %null_chk = icmp eq i64 %cast23, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.71, i64 4, ptr @sty_name.72, i64 12, i64 %null_ext, ptr @src_file.73, i64 111, i64 230)
  %name_ptr = getelementptr inbounds nuw %ParsedOption, ptr %po22, i32 0, i32 0
  %name24 = load ptr, ptr %name_ptr, align 8
  %name25 = load ptr, ptr %name, align 8
  %7 = call i32 @strcmp(ptr %name24, ptr %name25)
  %widen = sext i32 %7 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next16:                                     ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.74, i64 %tag, ptr @mu_file.75, i64 226)
  unreachable

sif_then:                                         ; preds = %march_arm15
  %8 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %ParsedOptionList, ptr %8, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %ParsedOptionList, ptr %8, i32 0, i32 1
  %9 = call ptr @forge_rc_alloc(i64 16)
  store ptr %9, ptr %pay_ptr27, align 8
  %10 = call ptr @forge_rc_alloc(i64 16)
  %name28 = load ptr, ptr %name, align 8
  %fld_ptr29 = getelementptr inbounds nuw %ParsedOption, ptr %10, i32 0, i32 0
  store ptr %name28, ptr %fld_ptr29, align 8
  %value30 = load ptr, ptr %value, align 8
  %fld_ptr31 = getelementptr inbounds nuw %ParsedOption, ptr %10, i32 0, i32 1
  store ptr %value30, ptr %fld_ptr31, align 8
  %cast32 = ptrtoint ptr %10 to i64
  %slot_base33 = ptrtoint ptr %9 to i64
  %slot_addr34 = add i64 %slot_base33, 0
  %slot35 = inttoptr i64 %slot_addr34 to ptr
  %cast36 = inttoptr i64 %cast32 to ptr
  store ptr %cast36, ptr %slot35, align 8
  %next37 = load ptr, ptr %next21, align 8
  %slot_base38 = ptrtoint ptr %9 to i64
  %slot_addr39 = add i64 %slot_base38, 8
  %slot40 = inttoptr i64 %slot_addr39 to ptr
  store ptr %next37, ptr %slot40, align 8
  %cast41 = ptrtoint ptr %8 to i64
  store i64 %cast41, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm15
  %11 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr42 = getelementptr inbounds nuw %ParsedOptionList, ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr42, align 8
  %pay_ptr43 = getelementptr inbounds nuw %ParsedOptionList, ptr %11, i32 0, i32 1
  %12 = call ptr @forge_rc_alloc(i64 16)
  store ptr %12, ptr %pay_ptr43, align 8
  %po44 = load ptr, ptr %po18, align 8
  %slot_base45 = ptrtoint ptr %12 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  store ptr %po44, ptr %slot47, align 8
  %next48 = load ptr, ptr %next21, align 8
  %name49 = load ptr, ptr %name, align 8
  %value50 = load ptr, ptr %value, align 8
  %13 = call ptr @set_option(ptr %next48, ptr %name49, ptr %value50)
  %slot_base51 = ptrtoint ptr %12 to i64
  %slot_addr52 = add i64 %slot_base51, 8
  %slot53 = inttoptr i64 %slot_addr52 to ptr
  store ptr %13, ptr %slot53, align 8
  %cast54 = ptrtoint ptr %11 to i64
  store i64 %cast54, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @arg_at(ptr %0, i64 %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %a5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %idx = alloca i64, align 8
  %args = alloca ptr, align 8
  store ptr %0, ptr %args, align 8
  store i64 %1, ptr %idx, align 8
  %args1 = load ptr, ptr %args, align 8
  %tag_ptr = getelementptr inbounds nuw %ArgList, ptr %args1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast14 = inttoptr i64 %match_val to ptr
  ret ptr %cast14

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ArgList, ptr %args1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %a_slot_base = ptrtoint ptr %payload to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a5, align 8
  %pay_slot6 = getelementptr inbounds nuw %ArgList, ptr %args1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %idx9 = load i64, ptr %idx, align 8
  %eq = icmp eq i64 %idx9, 0
  %eq_ext = zext i1 %eq to i64
  %sif_cond = icmp ne i64 %eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.76, i64 %tag, ptr @mu_file.77, i64 240)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %a10 = load ptr, ptr %a5, align 8
  %cast = ptrtoint ptr %a10 to i64
  store i64 %cast, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next11 = load ptr, ptr %next8, align 8
  %idx12 = load i64, ptr %idx, align 8
  %sub = sub i64 %idx12, 1
  %2 = call ptr @arg_at(ptr %next11, i64 %sub)
  %cast13 = ptrtoint ptr %2 to i64
  store i64 %cast13, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @find_command(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %cmd5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %name = alloca ptr, align 8
  %cmds = alloca ptr, align 8
  store ptr %0, ptr %cmds, align 8
  store ptr %1, ptr %name, align 8
  %cmds1 = load ptr, ptr %cmds, align 8
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast17 = inttoptr i64 %match_val to ptr
  ret ptr %cast17

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @forge_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd5, align 8
  %pay_slot6 = getelementptr inbounds nuw %CommandList, ptr %cmds1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %cmd9 = load ptr, ptr %cmd5, align 8
  %cast = ptrtoint ptr %cmd9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.78, i64 4, ptr @sty_name.79, i64 10, i64 %null_ext, ptr @src_file.80, i64 111, i64 254)
  %name_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd9, i32 0, i32 0
  %name10 = load ptr, ptr %name_ptr, align 8
  %name11 = load ptr, ptr %name, align 8
  %2 = call i32 @strcmp(ptr %name10, ptr %name11)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.81, i64 %tag, ptr @mu_file.82, i64 250)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %cmd12 = load ptr, ptr %cmd5, align 8
  %cast13 = ptrtoint ptr %cmd12 to i64
  store i64 %cast13, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next14 = load ptr, ptr %next8, align 8
  %name15 = load ptr, ptr %name, align 8
  %3 = call ptr @find_command(ptr %next14, ptr %name15)
  %cast16 = ptrtoint ptr %3 to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @parse_args(ptr %0, ptr %1, ptr %2, ptr %3, i64 %4, i64 %5) {
entry:
  %arg_def = alloca ptr, align 8
  %val = alloca ptr, align 8
  %key = alloca ptr, align 8
  %eq_idx = alloca i64, align 8
  %arg = alloca ptr, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %error = alloca ptr, align 8
  %positional_idx = alloca i64, align 8
  %parsed_args = alloca ptr, align 8
  %parsed_options = alloca ptr, align 8
  %parsed_flags = alloca ptr, align 8
  %argc = alloca i64, align 8
  %start_idx = alloca i64, align 8
  %args = alloca ptr, align 8
  %options = alloca ptr, align 8
  %flags = alloca ptr, align 8
  %cmd_name = alloca ptr, align 8
  store ptr %0, ptr %cmd_name, align 8
  store ptr %1, ptr %flags, align 8
  store ptr %2, ptr %options, align 8
  store ptr %3, ptr %args, align 8
  store i64 %4, ptr %start_idx, align 8
  store i64 %5, ptr %argc, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %parsed_flags, align 8
  %options2 = load ptr, ptr %options, align 8
  %7 = call ptr @init_option_defaults(ptr %options2)
  store ptr %7, ptr %parsed_options, align 8
  %8 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr3 = getelementptr inbounds nuw %ParsedArgList, ptr %8, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr3, align 8
  %pay_ptr4 = getelementptr inbounds nuw %ParsedArgList, ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr4, align 8
  %cast5 = ptrtoint ptr %8 to i64
  %cast6 = inttoptr i64 %cast5 to ptr
  store ptr %cast6, ptr %parsed_args, align 8
  store i64 0, ptr %positional_idx, align 8
  store ptr @.str.83, ptr %error, align 8
  %start_idx7 = load i64, ptr %start_idx, align 8
  %argc8 = load i64, ptr %argc, align 8
  store i64 %start_idx7, ptr %i, align 8
  store i64 %argc8, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i9 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i9, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i10 = load i64, ptr %i, align 8
  %9 = call ptr @forge_selfhost_get_arg_cstr(i64 %i10)
  store ptr %9, ptr %arg, align 8
  %arg11 = load ptr, ptr %arg, align 8
  %10 = call i64 @forge_str_starts_with(ptr %arg11, ptr @.str.84)
  %l_bool = icmp ne i64 %10, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

for.incr:                                         ; preds = %ifcont
  %i112 = load i64, ptr %i, align 8
  %for_next = add i64 %i112, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %11 = call ptr @forge_rc_alloc(i64 40)
  %cmd_name113 = load ptr, ptr %cmd_name, align 8
  %fld_ptr114 = getelementptr inbounds nuw %ParseResult, ptr %11, i32 0, i32 0
  store ptr %cmd_name113, ptr %fld_ptr114, align 8
  %parsed_flags115 = load ptr, ptr %parsed_flags, align 8
  %fld_ptr116 = getelementptr inbounds nuw %ParseResult, ptr %11, i32 0, i32 1
  store ptr %parsed_flags115, ptr %fld_ptr116, align 8
  %parsed_options117 = load ptr, ptr %parsed_options, align 8
  %fld_ptr118 = getelementptr inbounds nuw %ParseResult, ptr %11, i32 0, i32 2
  store ptr %parsed_options117, ptr %fld_ptr118, align 8
  %parsed_args119 = load ptr, ptr %parsed_args, align 8
  %fld_ptr120 = getelementptr inbounds nuw %ParseResult, ptr %11, i32 0, i32 3
  store ptr %parsed_args119, ptr %fld_ptr120, align 8
  %error121 = load ptr, ptr %error, align 8
  %fld_ptr122 = getelementptr inbounds nuw %ParseResult, ptr %11, i32 0, i32 4
  store ptr %error121, ptr %fld_ptr122, align 8
  %cast123 = ptrtoint ptr %11 to i64
  %cast124 = inttoptr i64 %cast123 to ptr
  ret ptr %cast124

sc_rhs:                                           ; preds = %for.body
  %arg12 = load ptr, ptr %arg, align 8
  %12 = call i64 @forge_str_starts_with(ptr %arg12, ptr @.str.85)
  %l_bool13 = icmp ne i64 %12, 0
  br i1 %l_bool13, label %sc_rhs14, label %sc_short15

sc_short:                                         ; preds = %for.body
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge21, %sc_short
  %sc_phi22 = phi i1 [ true, %sc_short ], [ %r_bool18, %sc_r_merge21 ]
  %sc_ext23 = zext i1 %sc_phi22 to i64
  %if_cond = icmp ne i64 %sc_ext23, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_rhs14:                                         ; preds = %sc_rhs
  %arg17 = load ptr, ptr %arg, align 8
  %13 = call i64 @strlen(ptr %arg17)
  %sgt = icmp sgt i64 %13, 1
  %sgt_ext = zext i1 %sgt to i64
  %r_bool = icmp ne i64 %sgt_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short15:                                       ; preds = %sc_rhs
  br label %sc_merge16

sc_merge16:                                       ; preds = %sc_r_merge, %sc_short15
  %sc_phi = phi i1 [ false, %sc_short15 ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %r_bool18 = icmp ne i64 %sc_ext, 0
  br i1 %r_bool18, label %sc_r_true19, label %sc_r_false20

sc_r_true:                                        ; preds = %sc_rhs14
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs14
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge16

sc_r_true19:                                      ; preds = %sc_merge16
  br label %sc_r_merge21

sc_r_false20:                                     ; preds = %sc_merge16
  br label %sc_r_merge21

sc_r_merge21:                                     ; preds = %sc_r_false20, %sc_r_true19
  br label %sc_merge

ifcont:                                           ; preds = %ifcont88, %ifcont26
  br label %for.incr

if_then:                                          ; preds = %sc_merge
  %flags24 = load ptr, ptr %flags, align 8
  %arg25 = load ptr, ptr %arg, align 8
  %14 = call i1 @is_flag_match(ptr %flags24, ptr %arg25)
  %widen = zext i1 %14 to i64
  %if_cond27 = icmp ne i64 %widen, 0
  br i1 %if_cond27, label %if_then28, label %if_else29

if_else:                                          ; preds = %sc_merge
  %args85 = load ptr, ptr %args, align 8
  %positional_idx86 = load i64, ptr %positional_idx, align 8
  %15 = call ptr @arg_at(ptr %args85, i64 %positional_idx86)
  store ptr %15, ptr %arg_def, align 8
  %arg_def87 = load ptr, ptr %arg_def, align 8
  %ne = icmp ne ptr %arg_def87, null
  %ne_ext = zext i1 %ne to i64
  %if_cond89 = icmp ne i64 %ne_ext, 0
  br i1 %if_cond89, label %if_then90, label %if_else91

ifcont26:                                         ; preds = %ifcont43, %if_then28
  br label %ifcont

if_then28:                                        ; preds = %if_then
  %16 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr30 = getelementptr inbounds nuw %ParsedFlagList, ptr %16, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr30, align 8
  %pay_ptr31 = getelementptr inbounds nuw %ParsedFlagList, ptr %16, i32 0, i32 1
  %17 = call ptr @forge_rc_alloc(i64 16)
  store ptr %17, ptr %pay_ptr31, align 8
  %18 = call ptr @forge_rc_alloc(i64 16)
  %arg32 = load ptr, ptr %arg, align 8
  %19 = call ptr @strip_dashes(ptr %arg32)
  %fld_ptr = getelementptr inbounds nuw %ParsedFlag, ptr %18, i32 0, i32 0
  store ptr %19, ptr %fld_ptr, align 8
  %fld_ptr33 = getelementptr inbounds nuw %ParsedFlag, ptr %18, i32 0, i32 1
  store i1 true, ptr %fld_ptr33, align 8
  %cast34 = ptrtoint ptr %18 to i64
  %slot_base = ptrtoint ptr %17 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast35 = inttoptr i64 %cast34 to ptr
  store ptr %cast35, ptr %slot, align 8
  %parsed_flags36 = load ptr, ptr %parsed_flags, align 8
  %slot_base37 = ptrtoint ptr %17 to i64
  %slot_addr38 = add i64 %slot_base37, 8
  %slot39 = inttoptr i64 %slot_addr38 to ptr
  store ptr %parsed_flags36, ptr %slot39, align 8
  %cast40 = ptrtoint ptr %16 to i64
  %cast41 = inttoptr i64 %cast40 to ptr
  store ptr %cast41, ptr %parsed_flags, align 8
  br label %ifcont26

if_else29:                                        ; preds = %if_then
  %arg42 = load ptr, ptr %arg, align 8
  %20 = call i64 @forge_str_contains(ptr %arg42, ptr @.str.86)
  %if_cond44 = icmp ne i64 %20, 0
  br i1 %if_cond44, label %if_then45, label %if_else46

ifcont43:                                         ; preds = %if_else46, %ifcont68
  br label %ifcont26

if_then45:                                        ; preds = %if_else29
  %arg47 = load ptr, ptr %arg, align 8
  %21 = call i64 @forge_str_index_of(ptr %arg47, ptr @.str.87)
  store i64 %21, ptr %eq_idx, align 8
  %arg48 = load ptr, ptr %arg, align 8
  %eq_idx49 = load i64, ptr %eq_idx, align 8
  %sub_len = sub i64 %eq_idx49, 0
  %sub_alloc = add i64 %sub_len, 1
  %22 = call ptr @forge_rc_alloc(i64 %sub_alloc)
  %cast50 = ptrtoint ptr %arg48 to i64
  %sub_off_int = add i64 %cast50, 0
  %cast51 = inttoptr i64 %sub_off_int to ptr
  %23 = call ptr @memcpy(ptr %22, ptr %cast51, i64 %sub_len)
  %cast52 = ptrtoint ptr %22 to i64
  %sub_nul_int = add i64 %cast52, %sub_len
  %cast53 = inttoptr i64 %sub_nul_int to ptr
  store i8 0, ptr %cast53, align 8
  store ptr %22, ptr %key, align 8
  %arg54 = load ptr, ptr %arg, align 8
  %eq_idx55 = load i64, ptr %eq_idx, align 8
  %add = add i64 %eq_idx55, 1
  %arg56 = load ptr, ptr %arg, align 8
  %24 = call i64 @strlen(ptr %arg56)
  %sub_len57 = sub i64 %24, %add
  %sub_alloc58 = add i64 %sub_len57, 1
  %25 = call ptr @forge_rc_alloc(i64 %sub_alloc58)
  %cast59 = ptrtoint ptr %arg54 to i64
  %sub_off_int60 = add i64 %cast59, %add
  %cast61 = inttoptr i64 %sub_off_int60 to ptr
  %26 = call ptr @memcpy(ptr %25, ptr %cast61, i64 %sub_len57)
  %cast62 = ptrtoint ptr %25 to i64
  %sub_nul_int63 = add i64 %cast62, %sub_len57
  %cast64 = inttoptr i64 %sub_nul_int63 to ptr
  store i8 0, ptr %cast64, align 8
  store ptr %25, ptr %val, align 8
  %options65 = load ptr, ptr %options, align 8
  %key66 = load ptr, ptr %key, align 8
  %27 = call i1 @is_option_match(ptr %options65, ptr %key66)
  %widen67 = zext i1 %27 to i64
  %if_cond69 = icmp ne i64 %widen67, 0
  br i1 %if_cond69, label %if_then70, label %if_else71

if_else46:                                        ; preds = %if_else29
  %arg78 = load ptr, ptr %arg, align 8
  %28 = call i64 @strlen(ptr @.str.89)
  %29 = call i64 @strlen(ptr %arg78)
  %concat_total79 = add i64 %28, %29
  %concat_size80 = add i64 %concat_total79, 1
  %30 = call ptr @forge_rc_alloc(i64 %concat_size80)
  %31 = call ptr @memcpy(ptr %30, ptr @.str.89, i64 %28)
  %cast81 = ptrtoint ptr %30 to i64
  %dst2_int82 = add i64 %cast81, %28
  %cast83 = inttoptr i64 %dst2_int82 to ptr
  %rhs_len_p184 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast83, ptr %arg78, i64 %rhs_len_p184)
  store ptr %30, ptr %error, align 8
  br label %ifcont43

ifcont68:                                         ; preds = %if_else71, %if_then70
  br label %ifcont43

if_then70:                                        ; preds = %if_then45
  %parsed_options72 = load ptr, ptr %parsed_options, align 8
  %key73 = load ptr, ptr %key, align 8
  %33 = call ptr @strip_dashes(ptr %key73)
  %val74 = load ptr, ptr %val, align 8
  %34 = call ptr @set_option(ptr %parsed_options72, ptr %33, ptr %val74)
  store ptr %34, ptr %parsed_options, align 8
  br label %ifcont68

if_else71:                                        ; preds = %if_then45
  %key75 = load ptr, ptr %key, align 8
  %35 = call i64 @strlen(ptr @.str.88)
  %36 = call i64 @strlen(ptr %key75)
  %concat_total = add i64 %35, %36
  %concat_size = add i64 %concat_total, 1
  %37 = call ptr @forge_rc_alloc(i64 %concat_size)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.88, i64 %35)
  %cast76 = ptrtoint ptr %37 to i64
  %dst2_int = add i64 %cast76, %35
  %cast77 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast77, ptr %key75, i64 %rhs_len_p1)
  store ptr %37, ptr %error, align 8
  br label %ifcont68

ifcont88:                                         ; preds = %if_else91, %if_then90
  %positional_idx110 = load i64, ptr %positional_idx, align 8
  %add111 = add i64 %positional_idx110, 1
  store i64 %add111, ptr %positional_idx, align 8
  br label %ifcont

if_then90:                                        ; preds = %if_else
  %40 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr92 = getelementptr inbounds nuw %ParsedArgList, ptr %40, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr92, align 8
  %pay_ptr93 = getelementptr inbounds nuw %ParsedArgList, ptr %40, i32 0, i32 1
  %41 = call ptr @forge_rc_alloc(i64 16)
  store ptr %41, ptr %pay_ptr93, align 8
  %42 = call ptr @forge_rc_alloc(i64 16)
  %arg_def94 = load ptr, ptr %arg_def, align 8
  %cast95 = ptrtoint ptr %arg_def94 to i64
  %null_chk = icmp eq i64 %cast95, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.90, i64 4, ptr @sty_name.91, i64 6, i64 %null_ext, ptr @src_file.92, i64 111, i64 291)
  %name_ptr = getelementptr inbounds nuw %ArgDef, ptr %arg_def94, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %fld_ptr96 = getelementptr inbounds nuw %ParsedArg, ptr %42, i32 0, i32 0
  store ptr %name, ptr %fld_ptr96, align 8
  %arg97 = load ptr, ptr %arg, align 8
  %fld_ptr98 = getelementptr inbounds nuw %ParsedArg, ptr %42, i32 0, i32 1
  store ptr %arg97, ptr %fld_ptr98, align 8
  %cast99 = ptrtoint ptr %42 to i64
  %slot_base100 = ptrtoint ptr %41 to i64
  %slot_addr101 = add i64 %slot_base100, 0
  %slot102 = inttoptr i64 %slot_addr101 to ptr
  %cast103 = inttoptr i64 %cast99 to ptr
  store ptr %cast103, ptr %slot102, align 8
  %parsed_args104 = load ptr, ptr %parsed_args, align 8
  %slot_base105 = ptrtoint ptr %41 to i64
  %slot_addr106 = add i64 %slot_base105, 8
  %slot107 = inttoptr i64 %slot_addr106 to ptr
  store ptr %parsed_args104, ptr %slot107, align 8
  %cast108 = ptrtoint ptr %40 to i64
  %cast109 = inttoptr i64 %cast108 to ptr
  store ptr %cast109, ptr %parsed_args, align 8
  br label %ifcont88

if_else91:                                        ; preds = %if_else
  br label %ifcont88
}

define ptr @cli_parse(ptr %0) {
entry:
  %cmd = alloca ptr, align 8
  %first_arg = alloca ptr, align 8
  %argc = alloca i64, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  %1 = call i64 @forge_selfhost_argc()
  store i64 %1, ptr %argc, align 8
  %argc1 = load i64, ptr %argc, align 8
  %slt = icmp slt i64 %argc1, 2
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @forge_selfhost_get_arg_cstr(i64 1)
  store ptr %2, ptr %first_arg, align 8
  %cli17 = load ptr, ptr %cli, align 8
  %cast18 = ptrtoint ptr %cli17 to i64
  %null_chk = icmp eq i64 %cast18, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.95, i64 8, ptr @sty_name.96, i64 3, i64 %null_ext, ptr @src_file.97, i64 111, i64 315)
  %commands_ptr = getelementptr inbounds nuw %Cli, ptr %cli17, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %first_arg19 = load ptr, ptr %first_arg, align 8
  %3 = call ptr @find_command(ptr %commands, ptr %first_arg19)
  store ptr %3, ptr %cmd, align 8
  %cmd20 = load ptr, ptr %cmd, align 8
  %ne = icmp ne ptr %cmd20, null
  %ne_ext = zext i1 %ne to i64
  %if_cond22 = icmp ne i64 %ne_ext, 0
  br i1 %if_cond22, label %if_then23, label %if_else24

if_then:                                          ; preds = %entry
  %4 = call ptr @forge_rc_alloc(i64 40)
  %fld_ptr = getelementptr inbounds nuw %ParseResult, ptr %4, i32 0, i32 0
  store ptr @.str.93, ptr %fld_ptr, align 8
  %5 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %fld_ptr2 = getelementptr inbounds nuw %ParseResult, ptr %4, i32 0, i32 1
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %6 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %ParsedOptionList, ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %ParsedOptionList, ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr5, align 8
  %cast6 = ptrtoint ptr %6 to i64
  %fld_ptr7 = getelementptr inbounds nuw %ParseResult, ptr %4, i32 0, i32 2
  %cast8 = inttoptr i64 %cast6 to ptr
  store ptr %cast8, ptr %fld_ptr7, align 8
  %7 = call ptr @forge_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %ParsedArgList, ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %ParsedArgList, ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr10, align 8
  %cast11 = ptrtoint ptr %7 to i64
  %fld_ptr12 = getelementptr inbounds nuw %ParseResult, ptr %4, i32 0, i32 3
  %cast13 = inttoptr i64 %cast11 to ptr
  store ptr %cast13, ptr %fld_ptr12, align 8
  %fld_ptr14 = getelementptr inbounds nuw %ParseResult, ptr %4, i32 0, i32 4
  store ptr @.str.94, ptr %fld_ptr14, align 8
  %cast15 = ptrtoint ptr %4 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  ret ptr %cast16

if_else:                                          ; preds = %entry
  br label %ifcont

ifcont21:                                         ; preds = %if_else24
  %cli60 = load ptr, ptr %cli, align 8
  %cast61 = ptrtoint ptr %cli60 to i64
  %null_chk62 = icmp eq i64 %cast61, 0
  %null_ext63 = zext i1 %null_chk62 to i64
  call void @forge_null_deref_trap(ptr @fld_name.120, i64 5, ptr @sty_name.121, i64 3, i64 %null_ext63, ptr @src_file.122, i64 111, i64 321)
  %flags_ptr64 = getelementptr inbounds nuw %Cli, ptr %cli60, i32 0, i32 4
  %flags65 = load ptr, ptr %flags_ptr64, align 8
  %cli66 = load ptr, ptr %cli, align 8
  %cast67 = ptrtoint ptr %cli66 to i64
  %null_chk68 = icmp eq i64 %cast67, 0
  %null_ext69 = zext i1 %null_chk68 to i64
  call void @forge_null_deref_trap(ptr @fld_name.123, i64 7, ptr @sty_name.124, i64 3, i64 %null_ext69, ptr @src_file.125, i64 111, i64 321)
  %options_ptr70 = getelementptr inbounds nuw %Cli, ptr %cli66, i32 0, i32 5
  %options71 = load ptr, ptr %options_ptr70, align 8
  %cli72 = load ptr, ptr %cli, align 8
  %cast73 = ptrtoint ptr %cli72 to i64
  %null_chk74 = icmp eq i64 %cast73, 0
  %null_ext75 = zext i1 %null_chk74 to i64
  call void @forge_null_deref_trap(ptr @fld_name.126, i64 4, ptr @sty_name.127, i64 3, i64 %null_ext75, ptr @src_file.128, i64 111, i64 321)
  %args_ptr76 = getelementptr inbounds nuw %Cli, ptr %cli72, i32 0, i32 6
  %args77 = load ptr, ptr %args_ptr76, align 8
  %argc78 = load i64, ptr %argc, align 8
  %8 = call ptr @parse_args(ptr @.str.119, ptr %flags65, ptr %options71, ptr %args77, i64 1, i64 %argc78)
  ret ptr %8

if_then23:                                        ; preds = %ifcont
  %cmd25 = load ptr, ptr %cmd, align 8
  %cast26 = ptrtoint ptr %cmd25 to i64
  %null_chk27 = icmp eq i64 %cast26, 0
  %null_ext28 = zext i1 %null_chk27 to i64
  call void @forge_null_deref_trap(ptr @fld_name.98, i64 4, ptr @sty_name.99, i64 10, i64 %null_ext28, ptr @src_file.100, i64 111, i64 317)
  %name_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd25, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %cmd29 = load ptr, ptr %cmd, align 8
  %cast30 = ptrtoint ptr %cmd29 to i64
  %null_chk31 = icmp eq i64 %cast30, 0
  %null_ext32 = zext i1 %null_chk31 to i64
  call void @forge_null_deref_trap(ptr @fld_name.101, i64 5, ptr @sty_name.102, i64 10, i64 %null_ext32, ptr @src_file.103, i64 111, i64 317)
  %flags_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd29, i32 0, i32 2
  %flags = load ptr, ptr %flags_ptr, align 8
  %cli33 = load ptr, ptr %cli, align 8
  %cast34 = ptrtoint ptr %cli33 to i64
  %null_chk35 = icmp eq i64 %cast34, 0
  %null_ext36 = zext i1 %null_chk35 to i64
  call void @forge_null_deref_trap(ptr @fld_name.104, i64 5, ptr @sty_name.105, i64 3, i64 %null_ext36, ptr @src_file.106, i64 111, i64 317)
  %flags_ptr37 = getelementptr inbounds nuw %Cli, ptr %cli33, i32 0, i32 4
  %flags38 = load ptr, ptr %flags_ptr37, align 8
  %9 = call ptr @merge_flags(ptr %flags, ptr %flags38)
  %cmd39 = load ptr, ptr %cmd, align 8
  %cast40 = ptrtoint ptr %cmd39 to i64
  %null_chk41 = icmp eq i64 %cast40, 0
  %null_ext42 = zext i1 %null_chk41 to i64
  call void @forge_null_deref_trap(ptr @fld_name.107, i64 7, ptr @sty_name.108, i64 10, i64 %null_ext42, ptr @src_file.109, i64 111, i64 317)
  %options_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd39, i32 0, i32 3
  %options = load ptr, ptr %options_ptr, align 8
  %cli43 = load ptr, ptr %cli, align 8
  %cast44 = ptrtoint ptr %cli43 to i64
  %null_chk45 = icmp eq i64 %cast44, 0
  %null_ext46 = zext i1 %null_chk45 to i64
  call void @forge_null_deref_trap(ptr @fld_name.110, i64 7, ptr @sty_name.111, i64 3, i64 %null_ext46, ptr @src_file.112, i64 111, i64 317)
  %options_ptr47 = getelementptr inbounds nuw %Cli, ptr %cli43, i32 0, i32 5
  %options48 = load ptr, ptr %options_ptr47, align 8
  %10 = call ptr @merge_options(ptr %options, ptr %options48)
  %cmd49 = load ptr, ptr %cmd, align 8
  %cast50 = ptrtoint ptr %cmd49 to i64
  %null_chk51 = icmp eq i64 %cast50, 0
  %null_ext52 = zext i1 %null_chk51 to i64
  call void @forge_null_deref_trap(ptr @fld_name.113, i64 4, ptr @sty_name.114, i64 10, i64 %null_ext52, ptr @src_file.115, i64 111, i64 317)
  %args_ptr = getelementptr inbounds nuw %CommandDef, ptr %cmd49, i32 0, i32 4
  %args = load ptr, ptr %args_ptr, align 8
  %cli53 = load ptr, ptr %cli, align 8
  %cast54 = ptrtoint ptr %cli53 to i64
  %null_chk55 = icmp eq i64 %cast54, 0
  %null_ext56 = zext i1 %null_chk55 to i64
  call void @forge_null_deref_trap(ptr @fld_name.116, i64 4, ptr @sty_name.117, i64 3, i64 %null_ext56, ptr @src_file.118, i64 111, i64 317)
  %args_ptr57 = getelementptr inbounds nuw %Cli, ptr %cli53, i32 0, i32 6
  %args58 = load ptr, ptr %args_ptr57, align 8
  %11 = call ptr @merge_arg_lists(ptr %args, ptr %args58)
  %argc59 = load i64, ptr %argc, align 8
  %12 = call ptr @parse_args(ptr %name, ptr %9, ptr %10, ptr %11, i64 2, i64 %argc59)
  ret ptr %12

if_else24:                                        ; preds = %ifcont
  br label %ifcont21
}

define i1 @result_has_flag(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.129, i64 5, ptr @sty_name.130, i64 11, i64 %null_ext, ptr @src_file.131, i64 111, i64 325)
  %flags_ptr = getelementptr inbounds nuw %ParseResult, ptr %result1, i32 0, i32 1
  %flags = load ptr, ptr %flags_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call i1 @has_parsed_flag(ptr %flags, ptr %name2)
  %widen = zext i1 %2 to i64
  %cast3 = trunc i64 %widen to i1
  ret i1 %cast3
}

define i1 @has_parsed_flag(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %f5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %name = alloca ptr, align 8
  %flags = alloca ptr, align 8
  store ptr %0, ptr %flags, align 8
  store ptr %1, ptr %name, align 8
  %flags1 = load ptr, ptr %flags, align 8
  %tag_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %flags1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = trunc i64 %match_val to i1
  ret i1 %cast20

march_arm:                                        ; preds = %entry
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ParsedFlagList, ptr %flags1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @forge_rc_retain(ptr %f)
  store ptr %f, ptr %f5, align 8
  %pay_slot6 = getelementptr inbounds nuw %ParsedFlagList, ptr %flags1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %f9 = load ptr, ptr %f5, align 8
  %cast = ptrtoint ptr %f9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.132, i64 4, ptr @sty_name.133, i64 10, i64 %null_ext, ptr @src_file.134, i64 111, i64 333)
  %name_ptr = getelementptr inbounds nuw %ParsedFlag, ptr %f9, i32 0, i32 0
  %name10 = load ptr, ptr %name_ptr, align 8
  %name11 = load ptr, ptr %name, align 8
  %2 = call i32 @strcmp(ptr %name10, ptr %name11)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.138, i64 %tag, ptr @mu_file.139, i64 329)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %f12 = load ptr, ptr %f5, align 8
  %cast13 = ptrtoint ptr %f12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.135, i64 5, ptr @sty_name.136, i64 10, i64 %null_ext15, ptr @src_file.137, i64 111, i64 333)
  %value_ptr = getelementptr inbounds nuw %ParsedFlag, ptr %f12, i32 0, i32 1
  %value = load i1, ptr %value_ptr, align 8
  %cast16 = zext i1 %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call i1 @has_parsed_flag(ptr %next17, ptr %name18)
  %widen19 = zext i1 %3 to i64
  store i64 %widen19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @result_get_option(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.140, i64 7, ptr @sty_name.141, i64 11, i64 %null_ext, ptr @src_file.142, i64 111, i64 339)
  %options_ptr = getelementptr inbounds nuw %ParseResult, ptr %result1, i32 0, i32 2
  %options = load ptr, ptr %options_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call ptr @get_parsed_option(ptr %options, ptr %name2)
  ret ptr %2
}

define ptr @get_parsed_option(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %o5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %name = alloca ptr, align 8
  %options = alloca ptr, align 8
  store ptr %0, ptr %options, align 8
  store ptr %1, ptr %name, align 8
  %options1 = load ptr, ptr %options, align 8
  %tag_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %options1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.143 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ParsedOptionList, ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @forge_rc_retain(ptr %o)
  store ptr %o, ptr %o5, align 8
  %pay_slot6 = getelementptr inbounds nuw %ParsedOptionList, ptr %options1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %o9 = load ptr, ptr %o5, align 8
  %cast = ptrtoint ptr %o9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.144, i64 4, ptr @sty_name.145, i64 12, i64 %null_ext, ptr @src_file.146, i64 111, i64 347)
  %name_ptr = getelementptr inbounds nuw %ParsedOption, ptr %o9, i32 0, i32 0
  %name10 = load ptr, ptr %name_ptr, align 8
  %name11 = load ptr, ptr %name, align 8
  %2 = call i32 @strcmp(ptr %name10, ptr %name11)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.150, i64 %tag, ptr @mu_file.151, i64 343)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %o12 = load ptr, ptr %o5, align 8
  %cast13 = ptrtoint ptr %o12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.147, i64 5, ptr @sty_name.148, i64 12, i64 %null_ext15, ptr @src_file.149, i64 111, i64 347)
  %value_ptr = getelementptr inbounds nuw %ParsedOption, ptr %o12, i32 0, i32 1
  %value = load ptr, ptr %value_ptr, align 8
  %cast16 = ptrtoint ptr %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call ptr @get_parsed_option(ptr %next17, ptr %name18)
  %cast19 = ptrtoint ptr %3 to i64
  store i64 %cast19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @result_get_arg(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.152, i64 4, ptr @sty_name.153, i64 11, i64 %null_ext, ptr @src_file.154, i64 111, i64 353)
  %args_ptr = getelementptr inbounds nuw %ParseResult, ptr %result1, i32 0, i32 3
  %args = load ptr, ptr %args_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call ptr @get_parsed_arg(ptr %args, ptr %name2)
  ret ptr %2
}

define ptr @get_parsed_arg(ptr %0, ptr %1) {
entry:
  %sif_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %a5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %name = alloca ptr, align 8
  %args = alloca ptr, align 8
  store ptr %0, ptr %args, align 8
  store ptr %1, ptr %name, align 8
  %args1 = load ptr, ptr %args, align 8
  %tag_ptr = getelementptr inbounds nuw %ParsedArgList, ptr %args1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.155 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %ParsedArgList, ptr %args1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %a_slot_base = ptrtoint ptr %payload to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @forge_rc_retain(ptr %a)
  store ptr %a, ptr %a5, align 8
  %pay_slot6 = getelementptr inbounds nuw %ParsedArgList, ptr %args1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @forge_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %a9 = load ptr, ptr %a5, align 8
  %cast = ptrtoint ptr %a9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.156, i64 4, ptr @sty_name.157, i64 9, i64 %null_ext, ptr @src_file.158, i64 111, i64 361)
  %name_ptr = getelementptr inbounds nuw %ParsedArg, ptr %a9, i32 0, i32 0
  %name10 = load ptr, ptr %name_ptr, align 8
  %name11 = load ptr, ptr %name, align 8
  %2 = call i32 @strcmp(ptr %name10, ptr %name11)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %sif_cond = icmp ne i64 %streq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @forge_match_unreachable(ptr @.match_fn.162, i64 %tag, ptr @mu_file.163, i64 357)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %a12 = load ptr, ptr %a5, align 8
  %cast13 = ptrtoint ptr %a12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @forge_null_deref_trap(ptr @fld_name.159, i64 5, ptr @sty_name.160, i64 9, i64 %null_ext15, ptr @src_file.161, i64 111, i64 361)
  %value_ptr = getelementptr inbounds nuw %ParsedArg, ptr %a12, i32 0, i32 1
  %value = load ptr, ptr %value_ptr, align 8
  %cast16 = ptrtoint ptr %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call ptr @get_parsed_arg(ptr %next17, ptr %name18)
  %cast19 = ptrtoint ptr %3 to i64
  store i64 %cast19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define i64 @main() {
entry:
  %result = alloca ptr, align 8
  %app = alloca ptr, align 8
  %0 = call ptr @cli_new(ptr @.str.164, ptr @.str.165, ptr @.str.166)
  store ptr %0, ptr %app, align 8
  %app1 = load ptr, ptr %app, align 8
  %1 = call ptr @cli_add_command(ptr %app1, ptr @.str.167, ptr @.str.168)
  store ptr %1, ptr %app, align 8
  %app2 = load ptr, ptr %app, align 8
  %2 = call ptr @cli_command_add_flag(ptr %app2, ptr @.str.169, ptr @.str.170, ptr @.str.171, ptr @.str.172)
  store ptr %2, ptr %app, align 8
  %app3 = load ptr, ptr %app, align 8
  %3 = call ptr @cli_command_add_option(ptr %app3, ptr @.str.173, ptr @.str.174, ptr @.str.175, ptr @.str.176, ptr @.str.177)
  store ptr %3, ptr %app, align 8
  %app4 = load ptr, ptr %app, align 8
  %4 = call ptr @cli_command_add_arg(ptr %app4, ptr @.str.178, ptr @.str.179, ptr @.str.180, i1 true)
  store ptr %4, ptr %app, align 8
  %app5 = load ptr, ptr %app, align 8
  %5 = call ptr @cli_parse(ptr %app5)
  store ptr %5, ptr %result, align 8
  %result6 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result6 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @forge_null_deref_trap(ptr @fld_name.182, i64 7, ptr @sty_name.183, i64 11, i64 %null_ext, ptr @src_file.184, i64 111, i64 376)
  %command_ptr = getelementptr inbounds nuw %ParseResult, ptr %result6, i32 0, i32 0
  %command = load ptr, ptr %command_ptr, align 8
  %6 = call i64 @strlen(ptr @.str.181)
  %7 = call i64 @strlen(ptr %command)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @forge_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr @.str.181, i64 %6)
  %cast7 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast7, %6
  %cast8 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr %command, i64 %rhs_len_p1)
  %11 = call i32 @puts(ptr %8)
  %widen = sext i32 %11 to i64
  %result9 = load ptr, ptr %result, align 8
  %12 = call i1 @result_has_flag(ptr %result9, ptr @.str.186)
  %widen10 = zext i1 %12 to i64
  %13 = call ptr @forge_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt, i64 %widen10)
  %widen11 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr @.str.185)
  %16 = call i64 @strlen(ptr %13)
  %concat_total12 = add i64 %15, %16
  %concat_size13 = add i64 %concat_total12, 1
  %17 = call ptr @forge_rc_alloc(i64 %concat_size13)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.185, i64 %15)
  %cast14 = ptrtoint ptr %17 to i64
  %dst2_int15 = add i64 %cast14, %15
  %cast16 = inttoptr i64 %dst2_int15 to ptr
  %rhs_len_p117 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast16, ptr %13, i64 %rhs_len_p117)
  %20 = call i32 @puts(ptr %17)
  %widen18 = sext i32 %20 to i64
  %result19 = load ptr, ptr %result, align 8
  %21 = call ptr @result_get_arg(ptr %result19, ptr @.str.188)
  %22 = call i64 @strlen(ptr @.str.187)
  %23 = call i64 @strlen(ptr %21)
  %concat_total20 = add i64 %22, %23
  %concat_size21 = add i64 %concat_total20, 1
  %24 = call ptr @forge_rc_alloc(i64 %concat_size21)
  %25 = call ptr @memcpy(ptr %24, ptr @.str.187, i64 %22)
  %cast22 = ptrtoint ptr %24 to i64
  %dst2_int23 = add i64 %cast22, %22
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast24, ptr %21, i64 %rhs_len_p125)
  %27 = call i32 @puts(ptr %24)
  %widen26 = sext i32 %27 to i64
  %result27 = load ptr, ptr %result, align 8
  %28 = call ptr @result_get_option(ptr %result27, ptr @.str.190)
  %29 = call i64 @strlen(ptr @.str.189)
  %30 = call i64 @strlen(ptr %28)
  %concat_total28 = add i64 %29, %30
  %concat_size29 = add i64 %concat_total28, 1
  %31 = call ptr @forge_rc_alloc(i64 %concat_size29)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.189, i64 %29)
  %cast30 = ptrtoint ptr %31 to i64
  %dst2_int31 = add i64 %cast30, %29
  %cast32 = inttoptr i64 %dst2_int31 to ptr
  %rhs_len_p133 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast32, ptr %28, i64 %rhs_len_p133)
  %34 = call i32 @puts(ptr %31)
  %widen34 = sext i32 %34 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %0 = call i32 @forge_test_summary()
  %widen = sext i32 %0 to i64
  call void @forge_rc_collect()
  ret i64 0
}

define i64 @__release_Cli(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_args_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  %rel_version_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 2
  %rel_version = load ptr, ptr %rel_version_ptr, align 8
  %is_null_version = icmp eq ptr %rel_version, null
  br i1 %is_null_version, label %rel_version_skip, label %rel_version_do

rel_description_do:                               ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_version_skip:                                 ; preds = %rel_version_do, %rel_description_skip
  %rel_commands_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 3
  %rel_commands = load ptr, ptr %rel_commands_ptr, align 8
  %is_null_commands = icmp eq ptr %rel_commands, null
  br i1 %is_null_commands, label %rel_commands_skip, label %rel_commands_do

rel_version_do:                                   ; preds = %rel_description_skip
  call void @forge_rc_release(ptr %rel_version)
  br label %rel_version_skip

rel_commands_skip:                                ; preds = %rel_commands_do, %rel_version_skip
  %rel_flags_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 4
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_commands_do:                                  ; preds = %rel_version_skip
  %2 = call i64 @__release_CommandList(ptr %rel_commands)
  br label %rel_commands_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_commands_skip
  %rel_options_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 5
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_commands_skip
  %3 = call i64 @__release_FlagList(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %Cli, ptr %0, i32 0, i32 6
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %4 = call i64 @__release_OptionList(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_args_do:                                      ; preds = %rel_options_skip
  %5 = call i64 @__release_ArgList(ptr %rel_args)
  br label %rel_args_skip
}

define i64 @__release_ParseResult(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_command_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 0
  %rel_command = load ptr, ptr %rel_command_ptr, align 8
  %is_null_command = icmp eq ptr %rel_command, null
  br i1 %is_null_command, label %rel_command_skip, label %rel_command_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_error_skip
  ret i64 0

rel_command_skip:                                 ; preds = %rel_command_do, %do_free
  %rel_flags_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 1
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_command_do:                                   ; preds = %do_free
  call void @forge_rc_release(ptr %rel_command)
  br label %rel_command_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_command_skip
  %rel_options_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 2
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_command_skip
  %2 = call i64 @__release_ParsedFlagList(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 3
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %3 = call i64 @__release_ParsedOptionList(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  %rel_error_ptr = getelementptr inbounds nuw %ParseResult, ptr %0, i32 0, i32 4
  %rel_error = load ptr, ptr %rel_error_ptr, align 8
  %is_null_error = icmp eq ptr %rel_error, null
  br i1 %is_null_error, label %rel_error_skip, label %rel_error_do

rel_args_do:                                      ; preds = %rel_options_skip
  %4 = call i64 @__release_ParsedArgList(ptr %rel_args)
  br label %rel_args_skip

rel_error_skip:                                   ; preds = %rel_error_do, %rel_args_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_error_do:                                     ; preds = %rel_args_skip
  call void @forge_rc_release(ptr %rel_error)
  br label %rel_error_skip
}

define i64 @__release_ParsedArg(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %ParsedArg, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_value_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_value_ptr = getelementptr inbounds nuw %ParsedArg, ptr %0, i32 0, i32 1
  %rel_value = load ptr, ptr %rel_value_ptr, align 8
  %is_null_value = icmp eq ptr %rel_value, null
  br i1 %is_null_value, label %rel_value_skip, label %rel_value_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_value_skip:                                   ; preds = %rel_value_do, %rel_name_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_value_do:                                     ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_value)
  br label %rel_value_skip
}

define i64 @__release_ParsedOption(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %ParsedOption, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_value_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_value_ptr = getelementptr inbounds nuw %ParsedOption, ptr %0, i32 0, i32 1
  %rel_value = load ptr, ptr %rel_value_ptr, align 8
  %is_null_value = icmp eq ptr %rel_value, null
  br i1 %is_null_value, label %rel_value_skip, label %rel_value_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_value_skip:                                   ; preds = %rel_value_do, %rel_name_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_value_do:                                     ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_value)
  br label %rel_value_skip
}

define i64 @__release_ParsedFlag(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %ParsedFlag, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @forge_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @__release_CommandDef(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %CommandDef, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_args_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %CommandDef, ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  %rel_flags_ptr = getelementptr inbounds nuw %CommandDef, ptr %0, i32 0, i32 2
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_description_do:                               ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_description_skip
  %rel_options_ptr = getelementptr inbounds nuw %CommandDef, ptr %0, i32 0, i32 3
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_description_skip
  %2 = call i64 @__release_FlagList(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %CommandDef, ptr %0, i32 0, i32 4
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %3 = call i64 @__release_OptionList(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_args_do:                                      ; preds = %rel_options_skip
  %4 = call i64 @__release_ArgList(ptr %rel_args)
  br label %rel_args_skip
}

define i64 @__release_ArgDef(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %ArgDef, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_description_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %ArgDef, ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_description_do:                               ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_description)
  br label %rel_description_skip
}

define i64 @__release_OptionDef(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %OptionDef, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_default_val_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_short_ptr = getelementptr inbounds nuw %OptionDef, ptr %0, i32 0, i32 1
  %rel_short = load ptr, ptr %rel_short_ptr, align 8
  %is_null_short = icmp eq ptr %rel_short, null
  br i1 %is_null_short, label %rel_short_skip, label %rel_short_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_short_skip:                                   ; preds = %rel_short_do, %rel_name_skip
  %rel_description_ptr = getelementptr inbounds nuw %OptionDef, ptr %0, i32 0, i32 2
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_short_do:                                     ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_short)
  br label %rel_short_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_short_skip
  %rel_default_val_ptr = getelementptr inbounds nuw %OptionDef, ptr %0, i32 0, i32 3
  %rel_default_val = load ptr, ptr %rel_default_val_ptr, align 8
  %is_null_default_val = icmp eq ptr %rel_default_val, null
  br i1 %is_null_default_val, label %rel_default_val_skip, label %rel_default_val_do

rel_description_do:                               ; preds = %rel_short_skip
  call void @forge_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_default_val_skip:                             ; preds = %rel_default_val_do, %rel_description_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_default_val_do:                               ; preds = %rel_description_skip
  call void @forge_rc_release(ptr %rel_default_val)
  br label %rel_default_val_skip
}

define i64 @__release_FlagDef(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %FlagDef, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_description_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_short_ptr = getelementptr inbounds nuw %FlagDef, ptr %0, i32 0, i32 1
  %rel_short = load ptr, ptr %rel_short_ptr, align 8
  %is_null_short = icmp eq ptr %rel_short, null
  br i1 %is_null_short, label %rel_short_skip, label %rel_short_do

rel_name_do:                                      ; preds = %do_free
  call void @forge_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_short_skip:                                   ; preds = %rel_short_do, %rel_name_skip
  %rel_description_ptr = getelementptr inbounds nuw %FlagDef, ptr %0, i32 0, i32 2
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_short_do:                                     ; preds = %rel_name_skip
  call void @forge_rc_release(ptr %rel_short)
  br label %rel_short_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_short_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_description_do:                               ; preds = %rel_short_skip
  call void @forge_rc_release(ptr %rel_description)
  br label %rel_description_skip
}

define i64 @__release_ParsedArgList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ParsedArgList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedArgList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %ParsedArgList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %ParsedArgList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_ParsedArg(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_ParsedArgList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_ParsedOptionList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedOptionList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %ParsedOptionList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %ParsedOptionList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_ParsedOption(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_ParsedOptionList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_ParsedFlagList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ParsedFlagList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %ParsedFlagList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %ParsedFlagList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_ParsedFlag(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_ParsedFlagList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_CommandList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %CommandList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %CommandList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %CommandList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %CommandList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_CommandDef(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_CommandList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_ArgList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %ArgList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %ArgList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %ArgList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %ArgList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_ArgDef(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_ArgList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_OptionList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %OptionList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %OptionList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %OptionList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %OptionList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_OptionDef(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_OptionList(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @__release_FlagList(ptr %0) {
entry:
  %1 = call i64 @forge_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %FlagList, ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %FlagList, ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @forge_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @forge_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %FlagList__Node, ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %FlagList__Node, ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @__release_FlagDef(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @__release_FlagList(ptr %vrel_next)
  br label %vrel_next_skip
}
