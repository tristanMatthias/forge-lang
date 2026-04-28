; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%"@std::cli::Cli" = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%"@std::cli::CommandList" = type { i64, ptr }
%"@std::cli::FlagList" = type { i64, ptr }
%"@std::cli::OptionList" = type { i64, ptr }
%"@std::cli::ArgList" = type { i64, ptr }
%"@std::cli::CommandDef" = type { ptr, ptr, ptr, ptr, ptr }
%"@std::cli::FlagDef" = type { ptr, ptr, ptr }
%"@std::cli::OptionDef" = type { ptr, ptr, ptr, ptr }
%"@std::cli::ArgDef" = type { ptr, ptr, i1 }
%"@std::cli::ParseResult" = type { ptr, ptr, ptr, ptr, ptr }
%"@std::cli::ParsedFlagList" = type { i64, ptr }
%"@std::cli::ParsedOptionList" = type { i64, ptr }
%"@std::cli::ParsedArgList" = type { i64, ptr }
%"@std::cli::ParsedFlag" = type { ptr, i1 }
%"@std::cli::ParsedArg" = type { ptr, ptr }
%"@std::cli::ParsedOption" = type { ptr, ptr }
%"@std::cli::ParsedArgList__Node" = type { ptr, ptr }
%"@std::cli::ParsedOptionList__Node" = type { ptr, ptr }
%"@std::cli::ParsedFlagList__Node" = type { ptr, ptr }
%"@std::cli::CommandList__Node" = type { ptr, ptr }
%"@std::cli::ArgList__Node" = type { ptr, ptr }
%"@std::cli::OptionList__Node" = type { ptr, ptr }
%"@std::cli::FlagList__Node" = type { ptr, ptr }

@fld_name = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.1 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.2 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.3 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.4 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.5 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.6 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.7 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.8 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.9 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.10 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.11 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.12 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.13 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.14 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.15 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.16 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.17 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.18 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.19 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.20 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.21 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.22 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.23 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.24 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn = private unnamed_addr constant [32 x i8] c"@std::cli::update_command_flags\00", align 1
@mu_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.25 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.26 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.27 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.28 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.29 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.30 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.31 = private unnamed_addr constant [34 x i8] c"@std::cli::update_command_options\00", align 1
@mu_file.32 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.33 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.34 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.35 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.36 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.37 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.38 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.39 = private unnamed_addr constant [31 x i8] c"@std::cli::update_command_args\00", align 1
@mu_file.40 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.41 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.42 = private unnamed_addr constant [7 x i8] c"--help\00", align 1
@.str.43 = private unnamed_addr constant [3 x i8] c"-h\00", align 1
@.str.44 = private unnamed_addr constant [10 x i8] c"--version\00", align 1
@.str.45 = private unnamed_addr constant [3 x i8] c"-V\00", align 1
@fld_name.46 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.47 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.48 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.49 = private unnamed_addr constant [3 x i8] c" v\00", align 1
@fld_name.50 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@sty_name.51 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.52 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.53 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.54 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.55 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.56 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.57 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.58 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.59 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.60 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.61 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.62 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.63 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.64 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.65 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.66 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.67 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.68 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.69 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.70 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.71 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.72 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.73 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.74 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.75 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.76 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.77 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.78 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.79 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.80 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.81 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.82 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.83 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.84 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.85 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.86 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.87 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.88 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.89 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.90 = private unnamed_addr constant [24 x i8] c"@std::cli::find_command\00", align 1
@mu_file.91 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.92 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.93 = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.94 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.95 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.96 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.97 = private unnamed_addr constant [17 x i8] c"unknown option: \00", align 1
@.str.98 = private unnamed_addr constant [15 x i8] c"unknown flag: \00", align 1
@fld_name.99 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.100 = private unnamed_addr constant [18 x i8] c"@std::cli::ArgDef\00", align 1
@src_file.101 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.102 = private unnamed_addr constant [4 x i8] c"arg\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.103 = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.104 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@fld_name.105 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.106 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.107 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.108 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.109 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.110 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.111 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.112 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.113 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.114 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.115 = private unnamed_addr constant [25 x i8] c"@std::cli::is_flag_match\00", align 1
@mu_file.116 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.117 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.118 = private unnamed_addr constant [21 x i8] c"@std::cli::OptionDef\00", align 1
@src_file.119 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.120 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.121 = private unnamed_addr constant [21 x i8] c"@std::cli::OptionDef\00", align 1
@src_file.122 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.123 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.124 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.125 = private unnamed_addr constant [21 x i8] c"@std::cli::OptionDef\00", align 1
@src_file.126 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.127 = private unnamed_addr constant [27 x i8] c"@std::cli::is_option_match\00", align 1
@mu_file.128 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.129 = private unnamed_addr constant [18 x i8] c"@std::cli::arg_at\00", align 1
@mu_file.130 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.131 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.132 = private unnamed_addr constant [21 x i8] c"@std::cli::OptionDef\00", align 1
@src_file.133 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.134 = private unnamed_addr constant [12 x i8] c"default_val\00", align 1
@sty_name.135 = private unnamed_addr constant [21 x i8] c"@std::cli::OptionDef\00", align 1
@src_file.136 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.137 = private unnamed_addr constant [32 x i8] c"@std::cli::init_option_defaults\00", align 1
@mu_file.138 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.139 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.140 = private unnamed_addr constant [24 x i8] c"@std::cli::ParsedOption\00", align 1
@src_file.141 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.142 = private unnamed_addr constant [22 x i8] c"@std::cli::set_option\00", align 1
@mu_file.143 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.144 = private unnamed_addr constant [23 x i8] c"@std::cli::merge_flags\00", align 1
@mu_file.145 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.146 = private unnamed_addr constant [25 x i8] c"@std::cli::merge_options\00", align 1
@mu_file.147 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.148 = private unnamed_addr constant [27 x i8] c"@std::cli::merge_arg_lists\00", align 1
@mu_file.149 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.150 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.151 = private unnamed_addr constant [23 x i8] c"@std::cli::ParseResult\00", align 1
@src_file.152 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.153 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.154 = private unnamed_addr constant [22 x i8] c"@std::cli::ParsedFlag\00", align 1
@src_file.155 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.156 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.157 = private unnamed_addr constant [22 x i8] c"@std::cli::ParsedFlag\00", align 1
@src_file.158 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.159 = private unnamed_addr constant [27 x i8] c"@std::cli::has_parsed_flag\00", align 1
@mu_file.160 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.161 = private unnamed_addr constant [8 x i8] c"options\00", align 1
@sty_name.162 = private unnamed_addr constant [23 x i8] c"@std::cli::ParseResult\00", align 1
@src_file.163 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.164 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.165 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.166 = private unnamed_addr constant [24 x i8] c"@std::cli::ParsedOption\00", align 1
@src_file.167 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.168 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.169 = private unnamed_addr constant [24 x i8] c"@std::cli::ParsedOption\00", align 1
@src_file.170 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.171 = private unnamed_addr constant [29 x i8] c"@std::cli::get_parsed_option\00", align 1
@mu_file.172 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.173 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@sty_name.174 = private unnamed_addr constant [23 x i8] c"@std::cli::ParseResult\00", align 1
@src_file.175 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.176 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.177 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.178 = private unnamed_addr constant [21 x i8] c"@std::cli::ParsedArg\00", align 1
@src_file.179 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.180 = private unnamed_addr constant [6 x i8] c"value\00", align 1
@sty_name.181 = private unnamed_addr constant [21 x i8] c"@std::cli::ParsedArg\00", align 1
@src_file.182 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.183 = private unnamed_addr constant [26 x i8] c"@std::cli::get_parsed_arg\00", align 1
@mu_file.184 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.185 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@sty_name.186 = private unnamed_addr constant [23 x i8] c"@std::cli::ParseResult\00", align 1
@src_file.187 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.188 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.189 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.190 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.191 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.192 = private unnamed_addr constant [3 x i8] c" v\00", align 1
@fld_name.193 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@sty_name.194 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.195 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@fld_name.196 = private unnamed_addr constant [12 x i8] c"description\00", align 1
@sty_name.197 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.198 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.199 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.200 = private unnamed_addr constant [12 x i8] c"description\00", align 1
@sty_name.201 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.202 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.203 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.204 = private unnamed_addr constant [7 x i8] c"USAGE:\00", align 1
@.str.205 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@fld_name.206 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.207 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.208 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.209 = private unnamed_addr constant [21 x i8] c" <command> [options]\00", align 1
@.str.210 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.211 = private unnamed_addr constant [9 x i8] c"commands\00", align 1
@sty_name.212 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.213 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.214 = private unnamed_addr constant [14 x i8] c"GLOBAL FLAGS:\00", align 1
@fld_name.215 = private unnamed_addr constant [6 x i8] c"flags\00", align 1
@sty_name.216 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.217 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.218 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@fld_name.219 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.220 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.221 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.222 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@fld_name.223 = private unnamed_addr constant [12 x i8] c"description\00", align 1
@sty_name.224 = private unnamed_addr constant [22 x i8] c"@std::cli::CommandDef\00", align 1
@src_file.225 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.match_fn.226 = private unnamed_addr constant [26 x i8] c"@std::cli::print_commands\00", align 1
@mu_file.227 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.228 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.229 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@fld_name.230 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.231 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.232 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.233 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.234 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.235 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@sty_name.236 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.237 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.238 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.239 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@fld_name.240 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.241 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.242 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.243 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@fld_name.244 = private unnamed_addr constant [12 x i8] c"description\00", align 1
@sty_name.245 = private unnamed_addr constant [19 x i8] c"@std::cli::FlagDef\00", align 1
@src_file.246 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.247 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.match_fn.248 = private unnamed_addr constant [23 x i8] c"@std::cli::print_flags\00", align 1
@mu_file.249 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1
@.str.250 = private unnamed_addr constant [4 x i8] c"app\00", align 1
@.str.251 = private unnamed_addr constant [5 x i8] c"desc\00", align 1
@.str.252 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@fld_name.253 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.254 = private unnamed_addr constant [15 x i8] c"@std::cli::Cli\00", align 1
@src_file.255 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/pkg_import/main.av\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

declare i64 @avra_selfhost_argc()

declare ptr @avra_selfhost_get_arg_cstr(i64)

declare i64 @avra_process_exit(i64)

define ptr @"@std::cli::cli_new"(ptr %0, ptr %1, ptr %2) {
entry:
  %version = alloca ptr, align 8
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  store ptr %1, ptr %description, align 8
  store ptr %2, ptr %version, align 8
  %3 = call ptr @avra_rc_alloc(i64 56)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %description2 = load ptr, ptr %description, align 8
  %fld_ptr3 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 1
  store ptr %description2, ptr %fld_ptr3, align 8
  %version4 = load ptr, ptr %version, align 8
  %fld_ptr5 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 2
  store ptr %version4, ptr %fld_ptr5, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %4, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %4 to i64
  %fld_ptr6 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 3
  %cast7 = inttoptr i64 %cast to ptr
  store ptr %cast7, ptr %fld_ptr6, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr8 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr8, align 8
  %pay_ptr9 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr9, align 8
  %cast10 = ptrtoint ptr %5 to i64
  %fld_ptr11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 4
  %cast12 = inttoptr i64 %cast10 to ptr
  store ptr %cast12, ptr %fld_ptr11, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr13 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr13, align 8
  %pay_ptr14 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr14, align 8
  %cast15 = ptrtoint ptr %6 to i64
  %fld_ptr16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 5
  %cast17 = inttoptr i64 %cast15 to ptr
  store ptr %cast17, ptr %fld_ptr16, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr18 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr18, align 8
  %pay_ptr19 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr19, align 8
  %cast20 = ptrtoint ptr %7 to i64
  %fld_ptr21 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %3, i32 0, i32 6
  %cast22 = inttoptr i64 %cast20 to ptr
  store ptr %cast22, ptr %fld_ptr21, align 8
  %cast23 = ptrtoint ptr %3 to i64
  %cast24 = inttoptr i64 %cast23 to ptr
  ret ptr %cast24
}

define ptr @"@std::cli::cli_add_command"(ptr %0, ptr %1, ptr %2) {
entry:
  %cmd = alloca ptr, align 8
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %description, align 8
  %3 = call ptr @avra_rc_alloc(i64 40)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %3, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %description2 = load ptr, ptr %description, align 8
  %fld_ptr3 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %3, i32 0, i32 1
  store ptr %description2, ptr %fld_ptr3, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %4, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %4, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %4 to i64
  %fld_ptr4 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %3, i32 0, i32 2
  %cast5 = inttoptr i64 %cast to ptr
  store ptr %cast5, ptr %fld_ptr4, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %5 to i64
  %fld_ptr9 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %3, i32 0, i32 3
  %cast10 = inttoptr i64 %cast8 to ptr
  store ptr %cast10, ptr %fld_ptr9, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr11 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr11, align 8
  %pay_ptr12 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr12, align 8
  %cast13 = ptrtoint ptr %6 to i64
  %fld_ptr14 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %3, i32 0, i32 4
  %cast15 = inttoptr i64 %cast13 to ptr
  store ptr %cast15, ptr %fld_ptr14, align 8
  %cast16 = ptrtoint ptr %3 to i64
  %cast17 = inttoptr i64 %cast16 to ptr
  store ptr %cast17, ptr %cmd, align 8
  %cli18 = load ptr, ptr %cli, align 8
  %7 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 1
  %with_cp_val20 = load ptr, ptr %with_cp_src19, align 8
  %with_cp_dst21 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 1
  store ptr %with_cp_val20, ptr %with_cp_dst21, align 8
  %with_cp_src22 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 2
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 2
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 3
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 3
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 4
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 4
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 5
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 5
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %with_cp_src34 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli18, i32 0, i32 6
  %with_cp_val35 = load ptr, ptr %with_cp_src34, align 8
  %with_cp_dst36 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 6
  store ptr %with_cp_val35, ptr %with_cp_dst36, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr37 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %8, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr37, align 8
  %pay_ptr38 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 16)
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
  call void @avra_null_deref_trap(ptr @fld_name, i64 8, ptr @sty_name, i64 14, i64 %null_ext, ptr @src_file, i64 101, i64 103)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli40, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %slot_base42 = ptrtoint ptr %9 to i64
  %slot_addr43 = add i64 %slot_base42, 8
  %slot44 = inttoptr i64 %slot_addr43 to ptr
  store ptr %commands, ptr %slot44, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %7, i32 0, i32 3
  store i64 %cast45, ptr %with_ovr, align 8
  %cast46 = ptrtoint ptr %7 to i64
  %cast47 = inttoptr i64 %cast46 to ptr
  ret ptr %cast47
}

define ptr @"@std::cli::cli_add_flag"(ptr %0, ptr %1, ptr %2, ptr %3) {
entry:
  %f = alloca ptr, align 8
  %description = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %short, align 8
  store ptr %3, ptr %description, align 8
  %4 = call ptr @avra_rc_alloc(i64 24)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %4, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %short2 = load ptr, ptr %short, align 8
  %fld_ptr3 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %4, i32 0, i32 1
  store ptr %short2, ptr %fld_ptr3, align 8
  %description4 = load ptr, ptr %description, align 8
  %fld_ptr5 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %4, i32 0, i32 2
  store ptr %description4, ptr %fld_ptr5, align 8
  %cast = ptrtoint ptr %4 to i64
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %f, align 8
  %cli7 = load ptr, ptr %cli, align 8
  %5 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src8 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 1
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 1
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 2
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 2
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 3
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 4
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 4
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %with_cp_src20 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 5
  %with_cp_val21 = load ptr, ptr %with_cp_src20, align 8
  %with_cp_dst22 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 5
  store ptr %with_cp_val21, ptr %with_cp_dst22, align 8
  %with_cp_src23 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 6
  %with_cp_val24 = load ptr, ptr %with_cp_src23, align 8
  %with_cp_dst25 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 6
  store ptr %with_cp_val24, ptr %with_cp_dst25, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %6, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 16)
  store ptr %7, ptr %pay_ptr, align 8
  %f26 = load ptr, ptr %f, align 8
  %slot_base = ptrtoint ptr %7 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %f26, ptr %slot, align 8
  %cli27 = load ptr, ptr %cli, align 8
  %cast28 = ptrtoint ptr %cli27 to i64
  %null_chk = icmp eq i64 %cast28, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 5, ptr @sty_name.2, i64 14, i64 %null_ext, ptr @src_file.3, i64 101, i64 108)
  %flags_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli27, i32 0, i32 4
  %flags = load ptr, ptr %flags_ptr, align 8
  %slot_base29 = ptrtoint ptr %7 to i64
  %slot_addr30 = add i64 %slot_base29, 8
  %slot31 = inttoptr i64 %slot_addr30 to ptr
  store ptr %flags, ptr %slot31, align 8
  %cast32 = ptrtoint ptr %6 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 4
  store i64 %cast32, ptr %with_ovr, align 8
  %cast33 = ptrtoint ptr %5 to i64
  %cast34 = inttoptr i64 %cast33 to ptr
  ret ptr %cast34
}

define ptr @"@std::cli::cli_add_option"(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4) {
entry:
  %o = alloca ptr, align 8
  %default_val = alloca ptr, align 8
  %description = alloca ptr, align 8
  %short = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %short, align 8
  store ptr %3, ptr %description, align 8
  store ptr %4, ptr %default_val, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %5, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %short2 = load ptr, ptr %short, align 8
  %fld_ptr3 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %5, i32 0, i32 1
  store ptr %short2, ptr %fld_ptr3, align 8
  %description4 = load ptr, ptr %description, align 8
  %fld_ptr5 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %5, i32 0, i32 2
  store ptr %description4, ptr %fld_ptr5, align 8
  %default_val6 = load ptr, ptr %default_val, align 8
  %fld_ptr7 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %5, i32 0, i32 3
  store ptr %default_val6, ptr %fld_ptr7, align 8
  %cast = ptrtoint ptr %5 to i64
  %cast8 = inttoptr i64 %cast to ptr
  store ptr %cast8, ptr %o, align 8
  %cli9 = load ptr, ptr %cli, align 8
  %6 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 1
  %with_cp_val11 = load ptr, ptr %with_cp_src10, align 8
  %with_cp_dst12 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 1
  store ptr %with_cp_val11, ptr %with_cp_dst12, align 8
  %with_cp_src13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 2
  %with_cp_val14 = load ptr, ptr %with_cp_src13, align 8
  %with_cp_dst15 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 2
  store ptr %with_cp_val14, ptr %with_cp_dst15, align 8
  %with_cp_src16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 3
  %with_cp_val17 = load ptr, ptr %with_cp_src16, align 8
  %with_cp_dst18 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 3
  store ptr %with_cp_val17, ptr %with_cp_dst18, align 8
  %with_cp_src19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 4
  %with_cp_val20 = load ptr, ptr %with_cp_src19, align 8
  %with_cp_dst21 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 4
  store ptr %with_cp_val20, ptr %with_cp_dst21, align 8
  %with_cp_src22 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 5
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 5
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli9, i32 0, i32 6
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 6
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %7, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %7, i32 0, i32 1
  %8 = call ptr @avra_rc_alloc(i64 16)
  store ptr %8, ptr %pay_ptr, align 8
  %o28 = load ptr, ptr %o, align 8
  %slot_base = ptrtoint ptr %8 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %o28, ptr %slot, align 8
  %cli29 = load ptr, ptr %cli, align 8
  %cast30 = ptrtoint ptr %cli29 to i64
  %null_chk = icmp eq i64 %cast30, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 7, ptr @sty_name.5, i64 14, i64 %null_ext, ptr @src_file.6, i64 101, i64 113)
  %options_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli29, i32 0, i32 5
  %options = load ptr, ptr %options_ptr, align 8
  %slot_base31 = ptrtoint ptr %8 to i64
  %slot_addr32 = add i64 %slot_base31, 8
  %slot33 = inttoptr i64 %slot_addr32 to ptr
  store ptr %options, ptr %slot33, align 8
  %cast34 = ptrtoint ptr %7 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 5
  store i64 %cast34, ptr %with_ovr, align 8
  %cast35 = ptrtoint ptr %6 to i64
  %cast36 = inttoptr i64 %cast35 to ptr
  ret ptr %cast36
}

define ptr @"@std::cli::cli_add_arg"(ptr %0, ptr %1, ptr %2, i1 %3) {
entry:
  %a = alloca ptr, align 8
  %required = alloca i1, align 1
  %description = alloca ptr, align 8
  %name = alloca ptr, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  store ptr %1, ptr %name, align 8
  store ptr %2, ptr %description, align 8
  store i1 %3, ptr %required, align 8
  %4 = call ptr @avra_rc_alloc(i64 24)
  %name1 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %4, i32 0, i32 0
  store ptr %name1, ptr %fld_ptr, align 8
  %description2 = load ptr, ptr %description, align 8
  %fld_ptr3 = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %4, i32 0, i32 1
  store ptr %description2, ptr %fld_ptr3, align 8
  %required4 = load i1, ptr %required, align 8
  %fld_ptr5 = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %4, i32 0, i32 2
  store i1 %required4, ptr %fld_ptr5, align 8
  %cast = ptrtoint ptr %4 to i64
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %a, align 8
  %cli7 = load ptr, ptr %cli, align 8
  %5 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src8 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 1
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 1
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 2
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 2
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 3
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 4
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 4
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %with_cp_src20 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 5
  %with_cp_val21 = load ptr, ptr %with_cp_src20, align 8
  %with_cp_dst22 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 5
  store ptr %with_cp_val21, ptr %with_cp_dst22, align 8
  %with_cp_src23 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli7, i32 0, i32 6
  %with_cp_val24 = load ptr, ptr %with_cp_src23, align 8
  %with_cp_dst25 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 6
  store ptr %with_cp_val24, ptr %with_cp_dst25, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %6, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %6, i32 0, i32 1
  %7 = call ptr @avra_rc_alloc(i64 16)
  store ptr %7, ptr %pay_ptr, align 8
  %a26 = load ptr, ptr %a, align 8
  %slot_base = ptrtoint ptr %7 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %a26, ptr %slot, align 8
  %cli27 = load ptr, ptr %cli, align 8
  %cast28 = ptrtoint ptr %cli27 to i64
  %null_chk = icmp eq i64 %cast28, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 4, ptr @sty_name.8, i64 14, i64 %null_ext, ptr @src_file.9, i64 101, i64 118)
  %args_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli27, i32 0, i32 6
  %args = load ptr, ptr %args_ptr, align 8
  %slot_base29 = ptrtoint ptr %7 to i64
  %slot_addr30 = add i64 %slot_base29, 8
  %slot31 = inttoptr i64 %slot_addr30 to ptr
  store ptr %args, ptr %slot31, align 8
  %cast32 = ptrtoint ptr %6 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 6
  store i64 %cast32, ptr %with_ovr, align 8
  %cast33 = ptrtoint ptr %5 to i64
  %cast34 = inttoptr i64 %cast33 to ptr
  ret ptr %cast34
}

define ptr @"@std::cli::cli_command_add_flag"(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4) {
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
  %5 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 8, ptr @sty_name.11, i64 14, i64 %null_ext, ptr @src_file.12, i64 101, i64 123)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %short23 = load ptr, ptr %short, align 8
  %description24 = load ptr, ptr %description, align 8
  %6 = call ptr @"@std::cli::update_command_flags"(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %short23, ptr %description24)
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %6, ptr %with_ovr, align 8
  %cast25 = ptrtoint ptr %5 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  ret ptr %cast26
}

define ptr @"@std::cli::cli_command_add_option"(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4, ptr %5) {
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
  %6 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 8, ptr @sty_name.14, i64 14, i64 %null_ext, ptr @src_file.15, i64 101, i64 127)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %short23 = load ptr, ptr %short, align 8
  %description24 = load ptr, ptr %description, align 8
  %default_val25 = load ptr, ptr %default_val, align 8
  %7 = call ptr @"@std::cli::update_command_options"(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %short23, ptr %description24, ptr %default_val25)
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %6, i32 0, i32 3
  store ptr %7, ptr %with_ovr, align 8
  %cast26 = ptrtoint ptr %6 to i64
  %cast27 = inttoptr i64 %cast26 to ptr
  ret ptr %cast27
}

define ptr @"@std::cli::cli_command_add_arg"(ptr %0, ptr %1, ptr %2, ptr %3, i1 %4) {
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
  %5 = call ptr @avra_rc_alloc(i64 56)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 1
  %with_cp_val3 = load ptr, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 1
  store ptr %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 2
  %with_cp_val6 = load ptr, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 2
  store ptr %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 3
  %with_cp_val9 = load ptr, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 4
  %with_cp_val12 = load ptr, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 4
  store ptr %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 5
  %with_cp_val15 = load ptr, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 5
  store ptr %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_cp_src17 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 6
  %with_cp_val18 = load ptr, ptr %with_cp_src17, align 8
  %with_cp_dst19 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 6
  store ptr %with_cp_val18, ptr %with_cp_dst19, align 8
  %cli20 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli20 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 8, ptr @sty_name.17, i64 14, i64 %null_ext, ptr @src_file.18, i64 101, i64 131)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli20, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %cmd_name21 = load ptr, ptr %cmd_name, align 8
  %name22 = load ptr, ptr %name, align 8
  %description23 = load ptr, ptr %description, align 8
  %required24 = load i1, ptr %required, align 8
  %6 = call ptr @"@std::cli::update_command_args"(ptr %commands, ptr %cmd_name21, ptr %name22, ptr %description23, i1 %required24)
  %with_ovr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %5, i32 0, i32 3
  store ptr %6, ptr %with_ovr, align 8
  %cast25 = ptrtoint ptr %5 to i64
  %cast26 = inttoptr i64 %cast25 to ptr
  ret ptr %cast26
}

define ptr @"@std::cli::update_command_flags"(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast73 = inttoptr i64 %match_val to ptr
  ret ptr %cast73

march_arm:                                        ; preds = %entry
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @avra_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 4, ptr @sty_name.20, i64 21, i64 %null_ext, ptr @src_file.21, i64 101, i64 139)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd10, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn, i64 %tag, ptr @mu_file, i64 135)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %7 = call ptr @avra_rc_alloc(i64 24)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %7, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %short15 = load ptr, ptr %short, align 8
  %fld_ptr16 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %7, i32 0, i32 1
  store ptr %short15, ptr %fld_ptr16, align 8
  %desc17 = load ptr, ptr %desc, align 8
  %fld_ptr18 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %7, i32 0, i32 2
  store ptr %desc17, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %7 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %f, align 8
  %cmd21 = load ptr, ptr %cmd6, align 8
  %8 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src22 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 1
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 1
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 2
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 2
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 3
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 3
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 4
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 4
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr34 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %9, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr34, align 8
  %pay_ptr35 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %9, i32 0, i32 1
  %10 = call ptr @avra_rc_alloc(i64 16)
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
  call void @avra_null_deref_trap(ptr @fld_name.22, i64 5, ptr @sty_name.23, i64 21, i64 %null_ext40, ptr @src_file.24, i64 101, i64 141)
  %flags_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd37, i32 0, i32 2
  %flags = load ptr, ptr %flags_ptr, align 8
  %slot_base41 = ptrtoint ptr %10 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr %flags, ptr %slot43, align 8
  %cast44 = ptrtoint ptr %9 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 2
  store i64 %cast44, ptr %with_ovr, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %updated, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %11, i32 0, i32 1
  %12 = call ptr @avra_rc_alloc(i64 16)
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
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr58 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %13, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr58, align 8
  %pay_ptr59 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %13, i32 0, i32 1
  %14 = call ptr @avra_rc_alloc(i64 16)
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
  %15 = call ptr @"@std::cli::update_command_flags"(ptr %next64, ptr %cmd_name65, ptr %name66, ptr %short67, ptr %desc68)
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

define ptr @"@std::cli::update_command_options"(ptr %0, ptr %1, ptr %2, ptr %3, ptr %4, ptr %5) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast76 = inttoptr i64 %match_val to ptr
  ret ptr %cast76

march_arm:                                        ; preds = %entry
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @avra_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 4, ptr @sty_name.26, i64 21, i64 %null_ext, ptr @src_file.27, i64 101, i64 155)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd10, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.31, i64 %tag, ptr @mu_file.32, i64 151)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %8 = call ptr @avra_rc_alloc(i64 32)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %8, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %short15 = load ptr, ptr %short, align 8
  %fld_ptr16 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %8, i32 0, i32 1
  store ptr %short15, ptr %fld_ptr16, align 8
  %desc17 = load ptr, ptr %desc, align 8
  %fld_ptr18 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %8, i32 0, i32 2
  store ptr %desc17, ptr %fld_ptr18, align 8
  %default_val19 = load ptr, ptr %default_val, align 8
  %fld_ptr20 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %8, i32 0, i32 3
  store ptr %default_val19, ptr %fld_ptr20, align 8
  %cast21 = ptrtoint ptr %8 to i64
  %cast22 = inttoptr i64 %cast21 to ptr
  store ptr %cast22, ptr %o, align 8
  %cmd23 = load ptr, ptr %cmd6, align 8
  %9 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd23, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src24 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd23, i32 0, i32 1
  %with_cp_val25 = load ptr, ptr %with_cp_src24, align 8
  %with_cp_dst26 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 1
  store ptr %with_cp_val25, ptr %with_cp_dst26, align 8
  %with_cp_src27 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd23, i32 0, i32 2
  %with_cp_val28 = load ptr, ptr %with_cp_src27, align 8
  %with_cp_dst29 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 2
  store ptr %with_cp_val28, ptr %with_cp_dst29, align 8
  %with_cp_src30 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd23, i32 0, i32 3
  %with_cp_val31 = load ptr, ptr %with_cp_src30, align 8
  %with_cp_dst32 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 3
  store ptr %with_cp_val31, ptr %with_cp_dst32, align 8
  %with_cp_src33 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd23, i32 0, i32 4
  %with_cp_val34 = load ptr, ptr %with_cp_src33, align 8
  %with_cp_dst35 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 4
  store ptr %with_cp_val34, ptr %with_cp_dst35, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr36 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %10, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr36, align 8
  %pay_ptr37 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %10, i32 0, i32 1
  %11 = call ptr @avra_rc_alloc(i64 16)
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
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 7, ptr @sty_name.29, i64 21, i64 %null_ext42, ptr @src_file.30, i64 101, i64 157)
  %options_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd39, i32 0, i32 3
  %options = load ptr, ptr %options_ptr, align 8
  %slot_base43 = ptrtoint ptr %11 to i64
  %slot_addr44 = add i64 %slot_base43, 8
  %slot45 = inttoptr i64 %slot_addr44 to ptr
  store ptr %options, ptr %slot45, align 8
  %cast46 = ptrtoint ptr %10 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %9, i32 0, i32 3
  store i64 %cast46, ptr %with_ovr, align 8
  %cast47 = ptrtoint ptr %9 to i64
  %cast48 = inttoptr i64 %cast47 to ptr
  store ptr %cast48, ptr %updated, align 8
  %12 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr49 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %12, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr49, align 8
  %pay_ptr50 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %12, i32 0, i32 1
  %13 = call ptr @avra_rc_alloc(i64 16)
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
  %14 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr60 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %14, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr60, align 8
  %pay_ptr61 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %14, i32 0, i32 1
  %15 = call ptr @avra_rc_alloc(i64 16)
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
  %16 = call ptr @"@std::cli::update_command_options"(ptr %next66, ptr %cmd_name67, ptr %name68, ptr %short69, ptr %desc70, ptr %default_val71)
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

define ptr @"@std::cli::update_command_args"(ptr %0, ptr %1, ptr %2, ptr %3, i1 %4) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast73 = inttoptr i64 %match_val to ptr
  ret ptr %cast73

march_arm:                                        ; preds = %entry
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @avra_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %cmd10 = load ptr, ptr %cmd6, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.33, i64 4, ptr @sty_name.34, i64 21, i64 %null_ext, ptr @src_file.35, i64 101, i64 171)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd10, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.39, i64 %tag, ptr @mu_file.40, i64 167)
  unreachable

sif_then:                                         ; preds = %march_arm3
  %7 = call ptr @avra_rc_alloc(i64 24)
  %name14 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %7, i32 0, i32 0
  store ptr %name14, ptr %fld_ptr, align 8
  %desc15 = load ptr, ptr %desc, align 8
  %fld_ptr16 = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %7, i32 0, i32 1
  store ptr %desc15, ptr %fld_ptr16, align 8
  %required17 = load i1, ptr %required, align 8
  %fld_ptr18 = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %7, i32 0, i32 2
  store i1 %required17, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %7 to i64
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %a, align 8
  %cmd21 = load ptr, ptr %cmd6, align 8
  %8 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src22 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 1
  %with_cp_val23 = load ptr, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 1
  store ptr %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 2
  %with_cp_val26 = load ptr, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 2
  store ptr %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 3
  %with_cp_val29 = load ptr, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 3
  store ptr %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd21, i32 0, i32 4
  %with_cp_val32 = load ptr, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 4
  store ptr %with_cp_val32, ptr %with_cp_dst33, align 8
  %9 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr34 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %9, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr34, align 8
  %pay_ptr35 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %9, i32 0, i32 1
  %10 = call ptr @avra_rc_alloc(i64 16)
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
  call void @avra_null_deref_trap(ptr @fld_name.36, i64 4, ptr @sty_name.37, i64 21, i64 %null_ext40, ptr @src_file.38, i64 101, i64 173)
  %args_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd37, i32 0, i32 4
  %args = load ptr, ptr %args_ptr, align 8
  %slot_base41 = ptrtoint ptr %10 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr %args, ptr %slot43, align 8
  %cast44 = ptrtoint ptr %9 to i64
  %with_ovr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %8, i32 0, i32 4
  store i64 %cast44, ptr %with_ovr, align 8
  %cast45 = ptrtoint ptr %8 to i64
  %cast46 = inttoptr i64 %cast45 to ptr
  store ptr %cast46, ptr %updated, align 8
  %11 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr47 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr47, align 8
  %pay_ptr48 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %11, i32 0, i32 1
  %12 = call ptr @avra_rc_alloc(i64 16)
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
  %13 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr58 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %13, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr58, align 8
  %pay_ptr59 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %13, i32 0, i32 1
  %14 = call ptr @avra_rc_alloc(i64 16)
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
  %15 = call ptr @"@std::cli::update_command_args"(ptr %next64, ptr %cmd_name65, ptr %name66, ptr %desc67, i1 %required68)
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

define ptr @"@std::cli::cli_parse"(ptr %0) {
entry:
  %cmd = alloca ptr, align 8
  %first_arg = alloca ptr, align 8
  %argc = alloca i64, align 8
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  %1 = call i64 @avra_selfhost_argc()
  store i64 %1, ptr %argc, align 8
  %argc1 = load i64, ptr %argc, align 8
  %slt = icmp slt i64 %argc1, 2
  %slt_ext = zext i1 %slt to i64
  %if_cond = icmp ne i64 %slt_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else
  %2 = call ptr @avra_selfhost_get_arg_cstr(i64 1)
  store ptr %2, ptr %first_arg, align 8
  %first_arg17 = load ptr, ptr %first_arg, align 8
  %3 = call i32 @strcmp(ptr %first_arg17, ptr @.str.42)
  %widen = sext i32 %3 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %l_bool = icmp ne i64 %streq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

if_then:                                          ; preds = %entry
  %4 = call ptr @avra_rc_alloc(i64 40)
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %4, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %5, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %5, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %5 to i64
  %fld_ptr2 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %4, i32 0, i32 1
  %cast3 = inttoptr i64 %cast to ptr
  store ptr %cast3, ptr %fld_ptr2, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr4 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr4, align 8
  %pay_ptr5 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr5, align 8
  %cast6 = ptrtoint ptr %6 to i64
  %fld_ptr7 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %4, i32 0, i32 2
  %cast8 = inttoptr i64 %cast6 to ptr
  store ptr %cast8, ptr %fld_ptr7, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr9 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr9, align 8
  %pay_ptr10 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr10, align 8
  %cast11 = ptrtoint ptr %7 to i64
  %fld_ptr12 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %4, i32 0, i32 3
  %cast13 = inttoptr i64 %cast11 to ptr
  store ptr %cast13, ptr %fld_ptr12, align 8
  %fld_ptr14 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %4, i32 0, i32 4
  store ptr @.str.41, ptr %fld_ptr14, align 8
  %cast15 = ptrtoint ptr %4 to i64
  %cast16 = inttoptr i64 %cast15 to ptr
  ret ptr %cast16

if_else:                                          ; preds = %entry
  br label %ifcont

sc_rhs:                                           ; preds = %ifcont
  %first_arg18 = load ptr, ptr %first_arg, align 8
  %8 = call i32 @strcmp(ptr %first_arg18, ptr @.str.43)
  %widen19 = sext i32 %8 to i64
  %streq_cmp20 = icmp eq i64 %widen19, 0
  %streq_ext21 = zext i1 %streq_cmp20 to i64
  %r_bool = icmp ne i64 %streq_ext21, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short:                                         ; preds = %ifcont
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge, %sc_short
  %sc_phi = phi i1 [ true, %sc_short ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %if_cond23 = icmp ne i64 %sc_ext, 0
  br i1 %if_cond23, label %if_then24, label %if_else25

sc_r_true:                                        ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge

ifcont22:                                         ; preds = %if_else25, %if_then24
  %first_arg27 = load ptr, ptr %first_arg, align 8
  %9 = call i32 @strcmp(ptr %first_arg27, ptr @.str.44)
  %widen28 = sext i32 %9 to i64
  %streq_cmp29 = icmp eq i64 %widen28, 0
  %streq_ext30 = zext i1 %streq_cmp29 to i64
  %l_bool31 = icmp ne i64 %streq_ext30, 0
  br i1 %l_bool31, label %sc_short33, label %sc_rhs32

if_then24:                                        ; preds = %sc_merge
  %cli26 = load ptr, ptr %cli, align 8
  %10 = call i64 @"@std::cli::cli_print_help"(ptr %cli26)
  %11 = call i64 @avra_process_exit(i64 0)
  br label %ifcont22

if_else25:                                        ; preds = %sc_merge
  br label %ifcont22

sc_rhs32:                                         ; preds = %ifcont22
  %first_arg35 = load ptr, ptr %first_arg, align 8
  %12 = call i32 @strcmp(ptr %first_arg35, ptr @.str.45)
  %widen36 = sext i32 %12 to i64
  %streq_cmp37 = icmp eq i64 %widen36, 0
  %streq_ext38 = zext i1 %streq_cmp37 to i64
  %r_bool39 = icmp ne i64 %streq_ext38, 0
  br i1 %r_bool39, label %sc_r_true40, label %sc_r_false41

sc_short33:                                       ; preds = %ifcont22
  br label %sc_merge34

sc_merge34:                                       ; preds = %sc_r_merge42, %sc_short33
  %sc_phi43 = phi i1 [ true, %sc_short33 ], [ %r_bool39, %sc_r_merge42 ]
  %sc_ext44 = zext i1 %sc_phi43 to i64
  %if_cond46 = icmp ne i64 %sc_ext44, 0
  br i1 %if_cond46, label %if_then47, label %if_else48

sc_r_true40:                                      ; preds = %sc_rhs32
  br label %sc_r_merge42

sc_r_false41:                                     ; preds = %sc_rhs32
  br label %sc_r_merge42

sc_r_merge42:                                     ; preds = %sc_r_false41, %sc_r_true40
  br label %sc_merge34

ifcont45:                                         ; preds = %if_else48, %if_then47
  %cli64 = load ptr, ptr %cli, align 8
  %cast65 = ptrtoint ptr %cli64 to i64
  %null_chk66 = icmp eq i64 %cast65, 0
  %null_ext67 = zext i1 %null_chk66 to i64
  call void @avra_null_deref_trap(ptr @fld_name.53, i64 8, ptr @sty_name.54, i64 14, i64 %null_ext67, ptr @src_file.55, i64 101, i64 209)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli64, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %first_arg68 = load ptr, ptr %first_arg, align 8
  %13 = call ptr @"@std::cli::find_command"(ptr %commands, ptr %first_arg68)
  store ptr %13, ptr %cmd, align 8
  %cmd69 = load ptr, ptr %cmd, align 8
  %ne = icmp ne ptr %cmd69, null
  %ne_ext = zext i1 %ne to i64
  %if_cond71 = icmp ne i64 %ne_ext, 0
  br i1 %if_cond71, label %if_then72, label %if_else73

if_then47:                                        ; preds = %sc_merge34
  %cli49 = load ptr, ptr %cli, align 8
  %cast50 = ptrtoint ptr %cli49 to i64
  %null_chk = icmp eq i64 %cast50, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.46, i64 4, ptr @sty_name.47, i64 14, i64 %null_ext, ptr @src_file.48, i64 101, i64 204)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli49, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %14 = call i64 @strlen(ptr %name)
  %15 = call i64 @strlen(ptr @.str.49)
  %concat_total = add i64 %14, %15
  %concat_size = add i64 %concat_total, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size)
  %17 = call ptr @memcpy(ptr %16, ptr %name, i64 %14)
  %cast51 = ptrtoint ptr %16 to i64
  %dst2_int = add i64 %cast51, %14
  %cast52 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast52, ptr @.str.49, i64 %rhs_len_p1)
  %cli53 = load ptr, ptr %cli, align 8
  %cast54 = ptrtoint ptr %cli53 to i64
  %null_chk55 = icmp eq i64 %cast54, 0
  %null_ext56 = zext i1 %null_chk55 to i64
  call void @avra_null_deref_trap(ptr @fld_name.50, i64 7, ptr @sty_name.51, i64 14, i64 %null_ext56, ptr @src_file.52, i64 101, i64 204)
  %version_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli53, i32 0, i32 2
  %version = load ptr, ptr %version_ptr, align 8
  %19 = call i64 @strlen(ptr %16)
  %20 = call i64 @strlen(ptr %version)
  %concat_total57 = add i64 %19, %20
  %concat_size58 = add i64 %concat_total57, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size58)
  %22 = call ptr @memcpy(ptr %21, ptr %16, i64 %19)
  %cast59 = ptrtoint ptr %21 to i64
  %dst2_int60 = add i64 %cast59, %19
  %cast61 = inttoptr i64 %dst2_int60 to ptr
  %rhs_len_p162 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast61, ptr %version, i64 %rhs_len_p162)
  %24 = call i32 @puts(ptr %21)
  %widen63 = sext i32 %24 to i64
  %25 = call i64 @avra_process_exit(i64 0)
  br label %ifcont45

if_else48:                                        ; preds = %sc_merge34
  br label %ifcont45

ifcont70:                                         ; preds = %if_else73
  %cli111 = load ptr, ptr %cli, align 8
  %cast112 = ptrtoint ptr %cli111 to i64
  %null_chk113 = icmp eq i64 %cast112, 0
  %null_ext114 = zext i1 %null_chk113 to i64
  call void @avra_null_deref_trap(ptr @fld_name.78, i64 5, ptr @sty_name.79, i64 14, i64 %null_ext114, ptr @src_file.80, i64 101, i64 218)
  %flags_ptr115 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli111, i32 0, i32 4
  %flags116 = load ptr, ptr %flags_ptr115, align 8
  %cli117 = load ptr, ptr %cli, align 8
  %cast118 = ptrtoint ptr %cli117 to i64
  %null_chk119 = icmp eq i64 %cast118, 0
  %null_ext120 = zext i1 %null_chk119 to i64
  call void @avra_null_deref_trap(ptr @fld_name.81, i64 7, ptr @sty_name.82, i64 14, i64 %null_ext120, ptr @src_file.83, i64 101, i64 218)
  %options_ptr121 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli117, i32 0, i32 5
  %options122 = load ptr, ptr %options_ptr121, align 8
  %cli123 = load ptr, ptr %cli, align 8
  %cast124 = ptrtoint ptr %cli123 to i64
  %null_chk125 = icmp eq i64 %cast124, 0
  %null_ext126 = zext i1 %null_chk125 to i64
  call void @avra_null_deref_trap(ptr @fld_name.84, i64 4, ptr @sty_name.85, i64 14, i64 %null_ext126, ptr @src_file.86, i64 101, i64 218)
  %args_ptr127 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli123, i32 0, i32 6
  %args128 = load ptr, ptr %args_ptr127, align 8
  %argc129 = load i64, ptr %argc, align 8
  %26 = call ptr @"@std::cli::parse_args"(ptr @.str.77, ptr %flags116, ptr %options122, ptr %args128, i64 1, i64 %argc129)
  ret ptr %26

if_then72:                                        ; preds = %ifcont45
  %cmd74 = load ptr, ptr %cmd, align 8
  %cast75 = ptrtoint ptr %cmd74 to i64
  %null_chk76 = icmp eq i64 %cast75, 0
  %null_ext77 = zext i1 %null_chk76 to i64
  call void @avra_null_deref_trap(ptr @fld_name.56, i64 4, ptr @sty_name.57, i64 21, i64 %null_ext77, ptr @src_file.58, i64 101, i64 212)
  %name_ptr78 = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd74, i32 0, i32 0
  %name79 = load ptr, ptr %name_ptr78, align 8
  %cmd80 = load ptr, ptr %cmd, align 8
  %cast81 = ptrtoint ptr %cmd80 to i64
  %null_chk82 = icmp eq i64 %cast81, 0
  %null_ext83 = zext i1 %null_chk82 to i64
  call void @avra_null_deref_trap(ptr @fld_name.59, i64 5, ptr @sty_name.60, i64 21, i64 %null_ext83, ptr @src_file.61, i64 101, i64 212)
  %flags_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd80, i32 0, i32 2
  %flags = load ptr, ptr %flags_ptr, align 8
  %cli84 = load ptr, ptr %cli, align 8
  %cast85 = ptrtoint ptr %cli84 to i64
  %null_chk86 = icmp eq i64 %cast85, 0
  %null_ext87 = zext i1 %null_chk86 to i64
  call void @avra_null_deref_trap(ptr @fld_name.62, i64 5, ptr @sty_name.63, i64 14, i64 %null_ext87, ptr @src_file.64, i64 101, i64 212)
  %flags_ptr88 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli84, i32 0, i32 4
  %flags89 = load ptr, ptr %flags_ptr88, align 8
  %27 = call ptr @"@std::cli::merge_flags"(ptr %flags, ptr %flags89)
  %cmd90 = load ptr, ptr %cmd, align 8
  %cast91 = ptrtoint ptr %cmd90 to i64
  %null_chk92 = icmp eq i64 %cast91, 0
  %null_ext93 = zext i1 %null_chk92 to i64
  call void @avra_null_deref_trap(ptr @fld_name.65, i64 7, ptr @sty_name.66, i64 21, i64 %null_ext93, ptr @src_file.67, i64 101, i64 212)
  %options_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd90, i32 0, i32 3
  %options = load ptr, ptr %options_ptr, align 8
  %cli94 = load ptr, ptr %cli, align 8
  %cast95 = ptrtoint ptr %cli94 to i64
  %null_chk96 = icmp eq i64 %cast95, 0
  %null_ext97 = zext i1 %null_chk96 to i64
  call void @avra_null_deref_trap(ptr @fld_name.68, i64 7, ptr @sty_name.69, i64 14, i64 %null_ext97, ptr @src_file.70, i64 101, i64 212)
  %options_ptr98 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli94, i32 0, i32 5
  %options99 = load ptr, ptr %options_ptr98, align 8
  %28 = call ptr @"@std::cli::merge_options"(ptr %options, ptr %options99)
  %cmd100 = load ptr, ptr %cmd, align 8
  %cast101 = ptrtoint ptr %cmd100 to i64
  %null_chk102 = icmp eq i64 %cast101, 0
  %null_ext103 = zext i1 %null_chk102 to i64
  call void @avra_null_deref_trap(ptr @fld_name.71, i64 4, ptr @sty_name.72, i64 21, i64 %null_ext103, ptr @src_file.73, i64 101, i64 212)
  %args_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd100, i32 0, i32 4
  %args = load ptr, ptr %args_ptr, align 8
  %cli104 = load ptr, ptr %cli, align 8
  %cast105 = ptrtoint ptr %cli104 to i64
  %null_chk106 = icmp eq i64 %cast105, 0
  %null_ext107 = zext i1 %null_chk106 to i64
  call void @avra_null_deref_trap(ptr @fld_name.74, i64 4, ptr @sty_name.75, i64 14, i64 %null_ext107, ptr @src_file.76, i64 101, i64 212)
  %args_ptr108 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli104, i32 0, i32 6
  %args109 = load ptr, ptr %args_ptr108, align 8
  %29 = call ptr @"@std::cli::merge_arg_lists"(ptr %args, ptr %args109)
  %argc110 = load i64, ptr %argc, align 8
  %30 = call ptr @"@std::cli::parse_args"(ptr %name79, ptr %27, ptr %28, ptr %29, i64 2, i64 %argc110)
  ret ptr %30

if_else73:                                        ; preds = %ifcont45
  br label %ifcont70
}

define ptr @"@std::cli::find_command"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @avra_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %cmd9 = load ptr, ptr %cmd5, align 8
  %cast = ptrtoint ptr %cmd9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.87, i64 4, ptr @sty_name.88, i64 21, i64 %null_ext, ptr @src_file.89, i64 101, i64 226)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd9, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.90, i64 %tag, ptr @mu_file.91, i64 222)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %cmd12 = load ptr, ptr %cmd5, align 8
  %cast13 = ptrtoint ptr %cmd12 to i64
  store i64 %cast13, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next14 = load ptr, ptr %next8, align 8
  %name15 = load ptr, ptr %name, align 8
  %3 = call ptr @"@std::cli::find_command"(ptr %next14, ptr %name15)
  %cast16 = ptrtoint ptr %3 to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @"@std::cli::parse_args"(ptr %0, ptr %1, ptr %2, ptr %3, i64 %4, i64 %5) {
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
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %6, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %6 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %parsed_flags, align 8
  %7 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %7, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr3 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %7, i32 0, i32 1
  store ptr null, ptr %pay_ptr3, align 8
  %cast4 = ptrtoint ptr %7 to i64
  %cast5 = inttoptr i64 %cast4 to ptr
  store ptr %cast5, ptr %parsed_options, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr6 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %8, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr6, align 8
  %pay_ptr7 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %8, i32 0, i32 1
  store ptr null, ptr %pay_ptr7, align 8
  %cast8 = ptrtoint ptr %8 to i64
  %cast9 = inttoptr i64 %cast8 to ptr
  store ptr %cast9, ptr %parsed_args, align 8
  store i64 0, ptr %positional_idx, align 8
  store ptr @.str.92, ptr %error, align 8
  %options10 = load ptr, ptr %options, align 8
  %9 = call ptr @"@std::cli::init_option_defaults"(ptr %options10)
  store ptr %9, ptr %parsed_options, align 8
  %start_idx11 = load i64, ptr %start_idx, align 8
  %argc12 = load i64, ptr %argc, align 8
  store i64 %start_idx11, ptr %i, align 8
  store i64 %argc12, ptr %for_end, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i13 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i13, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i14 = load i64, ptr %i, align 8
  %10 = call ptr @avra_selfhost_get_arg_cstr(i64 %i14)
  store ptr %10, ptr %arg, align 8
  %arg15 = load ptr, ptr %arg, align 8
  %11 = call i64 @avra_str_starts_with(ptr %arg15, ptr @.str.93)
  %l_bool = icmp ne i64 %11, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

for.incr:                                         ; preds = %ifcont
  %i140 = load i64, ptr %i, align 8
  %for_next = add i64 %i140, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  %12 = call ptr @avra_rc_alloc(i64 40)
  %cmd_name141 = load ptr, ptr %cmd_name, align 8
  %fld_ptr142 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %12, i32 0, i32 0
  store ptr %cmd_name141, ptr %fld_ptr142, align 8
  %parsed_flags143 = load ptr, ptr %parsed_flags, align 8
  %fld_ptr144 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %12, i32 0, i32 1
  store ptr %parsed_flags143, ptr %fld_ptr144, align 8
  %parsed_options145 = load ptr, ptr %parsed_options, align 8
  %fld_ptr146 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %12, i32 0, i32 2
  store ptr %parsed_options145, ptr %fld_ptr146, align 8
  %parsed_args147 = load ptr, ptr %parsed_args, align 8
  %fld_ptr148 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %12, i32 0, i32 3
  store ptr %parsed_args147, ptr %fld_ptr148, align 8
  %error149 = load ptr, ptr %error, align 8
  %fld_ptr150 = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %12, i32 0, i32 4
  store ptr %error149, ptr %fld_ptr150, align 8
  %cast151 = ptrtoint ptr %12 to i64
  %cast152 = inttoptr i64 %cast151 to ptr
  ret ptr %cast152

sc_rhs:                                           ; preds = %for.body
  %arg16 = load ptr, ptr %arg, align 8
  %13 = call i64 @avra_str_starts_with(ptr %arg16, ptr @.str.94)
  %l_bool17 = icmp ne i64 %13, 0
  br i1 %l_bool17, label %sc_rhs18, label %sc_short19

sc_short:                                         ; preds = %for.body
  br label %sc_merge

sc_merge:                                         ; preds = %sc_r_merge25, %sc_short
  %sc_phi26 = phi i1 [ true, %sc_short ], [ %r_bool22, %sc_r_merge25 ]
  %sc_ext27 = zext i1 %sc_phi26 to i64
  %if_cond = icmp ne i64 %sc_ext27, 0
  br i1 %if_cond, label %if_then, label %if_else

sc_rhs18:                                         ; preds = %sc_rhs
  %arg21 = load ptr, ptr %arg, align 8
  %14 = call i64 @strlen(ptr %arg21)
  %sgt = icmp sgt i64 %14, 1
  %sgt_ext = zext i1 %sgt to i64
  %r_bool = icmp ne i64 %sgt_ext, 0
  br i1 %r_bool, label %sc_r_true, label %sc_r_false

sc_short19:                                       ; preds = %sc_rhs
  br label %sc_merge20

sc_merge20:                                       ; preds = %sc_r_merge, %sc_short19
  %sc_phi = phi i1 [ false, %sc_short19 ], [ %r_bool, %sc_r_merge ]
  %sc_ext = zext i1 %sc_phi to i64
  %r_bool22 = icmp ne i64 %sc_ext, 0
  br i1 %r_bool22, label %sc_r_true23, label %sc_r_false24

sc_r_true:                                        ; preds = %sc_rhs18
  br label %sc_r_merge

sc_r_false:                                       ; preds = %sc_rhs18
  br label %sc_r_merge

sc_r_merge:                                       ; preds = %sc_r_false, %sc_r_true
  br label %sc_merge20

sc_r_true23:                                      ; preds = %sc_merge20
  br label %sc_r_merge25

sc_r_false24:                                     ; preds = %sc_merge20
  br label %sc_r_merge25

sc_r_merge25:                                     ; preds = %sc_r_false24, %sc_r_true23
  br label %sc_merge

ifcont:                                           ; preds = %ifcont92, %ifcont30
  br label %for.incr

if_then:                                          ; preds = %sc_merge
  %flags28 = load ptr, ptr %flags, align 8
  %arg29 = load ptr, ptr %arg, align 8
  %15 = call i1 @"@std::cli::is_flag_match"(ptr %flags28, ptr %arg29)
  %widen = zext i1 %15 to i64
  %if_cond31 = icmp ne i64 %widen, 0
  br i1 %if_cond31, label %if_then32, label %if_else33

if_else:                                          ; preds = %sc_merge
  %args89 = load ptr, ptr %args, align 8
  %positional_idx90 = load i64, ptr %positional_idx, align 8
  %16 = call ptr @"@std::cli::arg_at"(ptr %args89, i64 %positional_idx90)
  store ptr %16, ptr %arg_def, align 8
  %arg_def91 = load ptr, ptr %arg_def, align 8
  %ne = icmp ne ptr %arg_def91, null
  %ne_ext = zext i1 %ne to i64
  %if_cond93 = icmp ne i64 %ne_ext, 0
  br i1 %if_cond93, label %if_then94, label %if_else95

ifcont30:                                         ; preds = %ifcont47, %if_then32
  br label %ifcont

if_then32:                                        ; preds = %if_then
  %17 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr34 = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %17, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr34, align 8
  %pay_ptr35 = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %17, i32 0, i32 1
  %18 = call ptr @avra_rc_alloc(i64 16)
  store ptr %18, ptr %pay_ptr35, align 8
  %19 = call ptr @avra_rc_alloc(i64 16)
  %arg36 = load ptr, ptr %arg, align 8
  %20 = call ptr @"@std::cli::strip_dashes"(ptr %arg36)
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlag", ptr %19, i32 0, i32 0
  store ptr %20, ptr %fld_ptr, align 8
  %fld_ptr37 = getelementptr inbounds nuw %"@std::cli::ParsedFlag", ptr %19, i32 0, i32 1
  store i1 true, ptr %fld_ptr37, align 8
  %cast38 = ptrtoint ptr %19 to i64
  %slot_base = ptrtoint ptr %18 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast39 = inttoptr i64 %cast38 to ptr
  store ptr %cast39, ptr %slot, align 8
  %parsed_flags40 = load ptr, ptr %parsed_flags, align 8
  %slot_base41 = ptrtoint ptr %18 to i64
  %slot_addr42 = add i64 %slot_base41, 8
  %slot43 = inttoptr i64 %slot_addr42 to ptr
  store ptr %parsed_flags40, ptr %slot43, align 8
  %cast44 = ptrtoint ptr %17 to i64
  %cast45 = inttoptr i64 %cast44 to ptr
  store ptr %cast45, ptr %parsed_flags, align 8
  br label %ifcont30

if_else33:                                        ; preds = %if_then
  %arg46 = load ptr, ptr %arg, align 8
  %21 = call i64 @avra_str_contains(ptr %arg46, ptr @.str.95)
  %if_cond48 = icmp ne i64 %21, 0
  br i1 %if_cond48, label %if_then49, label %if_else50

ifcont47:                                         ; preds = %if_else50, %ifcont72
  br label %ifcont30

if_then49:                                        ; preds = %if_else33
  %arg51 = load ptr, ptr %arg, align 8
  %22 = call i64 @avra_str_index_of(ptr %arg51, ptr @.str.96)
  store i64 %22, ptr %eq_idx, align 8
  %arg52 = load ptr, ptr %arg, align 8
  %eq_idx53 = load i64, ptr %eq_idx, align 8
  %sub_len = sub i64 %eq_idx53, 0
  %sub_alloc = add i64 %sub_len, 1
  %23 = call ptr @avra_rc_alloc(i64 %sub_alloc)
  %cast54 = ptrtoint ptr %arg52 to i64
  %sub_off_int = add i64 %cast54, 0
  %cast55 = inttoptr i64 %sub_off_int to ptr
  %24 = call ptr @memcpy(ptr %23, ptr %cast55, i64 %sub_len)
  %cast56 = ptrtoint ptr %23 to i64
  %sub_nul_int = add i64 %cast56, %sub_len
  %cast57 = inttoptr i64 %sub_nul_int to ptr
  store i8 0, ptr %cast57, align 8
  store ptr %23, ptr %key, align 8
  %arg58 = load ptr, ptr %arg, align 8
  %eq_idx59 = load i64, ptr %eq_idx, align 8
  %add = add i64 %eq_idx59, 1
  %arg60 = load ptr, ptr %arg, align 8
  %25 = call i64 @strlen(ptr %arg60)
  %sub_len61 = sub i64 %25, %add
  %sub_alloc62 = add i64 %sub_len61, 1
  %26 = call ptr @avra_rc_alloc(i64 %sub_alloc62)
  %cast63 = ptrtoint ptr %arg58 to i64
  %sub_off_int64 = add i64 %cast63, %add
  %cast65 = inttoptr i64 %sub_off_int64 to ptr
  %27 = call ptr @memcpy(ptr %26, ptr %cast65, i64 %sub_len61)
  %cast66 = ptrtoint ptr %26 to i64
  %sub_nul_int67 = add i64 %cast66, %sub_len61
  %cast68 = inttoptr i64 %sub_nul_int67 to ptr
  store i8 0, ptr %cast68, align 8
  store ptr %26, ptr %val, align 8
  %options69 = load ptr, ptr %options, align 8
  %key70 = load ptr, ptr %key, align 8
  %28 = call i1 @"@std::cli::is_option_match"(ptr %options69, ptr %key70)
  %widen71 = zext i1 %28 to i64
  %if_cond73 = icmp ne i64 %widen71, 0
  br i1 %if_cond73, label %if_then74, label %if_else75

if_else50:                                        ; preds = %if_else33
  %arg82 = load ptr, ptr %arg, align 8
  %29 = call i64 @strlen(ptr @.str.98)
  %30 = call i64 @strlen(ptr %arg82)
  %concat_total83 = add i64 %29, %30
  %concat_size84 = add i64 %concat_total83, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size84)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.98, i64 %29)
  %cast85 = ptrtoint ptr %31 to i64
  %dst2_int86 = add i64 %cast85, %29
  %cast87 = inttoptr i64 %dst2_int86 to ptr
  %rhs_len_p188 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast87, ptr %arg82, i64 %rhs_len_p188)
  store ptr %31, ptr %error, align 8
  br label %ifcont47

ifcont72:                                         ; preds = %if_else75, %if_then74
  br label %ifcont47

if_then74:                                        ; preds = %if_then49
  %parsed_options76 = load ptr, ptr %parsed_options, align 8
  %key77 = load ptr, ptr %key, align 8
  %34 = call ptr @"@std::cli::strip_dashes"(ptr %key77)
  %val78 = load ptr, ptr %val, align 8
  %35 = call ptr @"@std::cli::set_option"(ptr %parsed_options76, ptr %34, ptr %val78)
  store ptr %35, ptr %parsed_options, align 8
  br label %ifcont72

if_else75:                                        ; preds = %if_then49
  %key79 = load ptr, ptr %key, align 8
  %36 = call i64 @strlen(ptr @.str.97)
  %37 = call i64 @strlen(ptr %key79)
  %concat_total = add i64 %36, %37
  %concat_size = add i64 %concat_total, 1
  %38 = call ptr @avra_rc_alloc(i64 %concat_size)
  %39 = call ptr @memcpy(ptr %38, ptr @.str.97, i64 %36)
  %cast80 = ptrtoint ptr %38 to i64
  %dst2_int = add i64 %cast80, %36
  %cast81 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %37, 1
  %40 = call ptr @memcpy(ptr %cast81, ptr %key79, i64 %rhs_len_p1)
  store ptr %38, ptr %error, align 8
  br label %ifcont72

ifcont92:                                         ; preds = %if_else95, %if_then94
  %positional_idx138 = load i64, ptr %positional_idx, align 8
  %add139 = add i64 %positional_idx138, 1
  store i64 %add139, ptr %positional_idx, align 8
  br label %ifcont

if_then94:                                        ; preds = %if_else
  %41 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr96 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %41, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr96, align 8
  %pay_ptr97 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %41, i32 0, i32 1
  %42 = call ptr @avra_rc_alloc(i64 16)
  store ptr %42, ptr %pay_ptr97, align 8
  %43 = call ptr @avra_rc_alloc(i64 16)
  %arg_def98 = load ptr, ptr %arg_def, align 8
  %cast99 = ptrtoint ptr %arg_def98 to i64
  %null_chk = icmp eq i64 %cast99, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.99, i64 4, ptr @sty_name.100, i64 17, i64 %null_ext, ptr @src_file.101, i64 101, i64 272)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %arg_def98, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %fld_ptr100 = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %43, i32 0, i32 0
  store ptr %name, ptr %fld_ptr100, align 8
  %arg101 = load ptr, ptr %arg, align 8
  %fld_ptr102 = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %43, i32 0, i32 1
  store ptr %arg101, ptr %fld_ptr102, align 8
  %cast103 = ptrtoint ptr %43 to i64
  %slot_base104 = ptrtoint ptr %42 to i64
  %slot_addr105 = add i64 %slot_base104, 0
  %slot106 = inttoptr i64 %slot_addr105 to ptr
  %cast107 = inttoptr i64 %cast103 to ptr
  store ptr %cast107, ptr %slot106, align 8
  %parsed_args108 = load ptr, ptr %parsed_args, align 8
  %slot_base109 = ptrtoint ptr %42 to i64
  %slot_addr110 = add i64 %slot_base109, 8
  %slot111 = inttoptr i64 %slot_addr110 to ptr
  store ptr %parsed_args108, ptr %slot111, align 8
  %cast112 = ptrtoint ptr %41 to i64
  %cast113 = inttoptr i64 %cast112 to ptr
  store ptr %cast113, ptr %parsed_args, align 8
  br label %ifcont92

if_else95:                                        ; preds = %if_else
  %44 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr114 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %44, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr114, align 8
  %pay_ptr115 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %44, i32 0, i32 1
  %45 = call ptr @avra_rc_alloc(i64 16)
  store ptr %45, ptr %pay_ptr115, align 8
  %46 = call ptr @avra_rc_alloc(i64 16)
  %positional_idx116 = load i64, ptr %positional_idx, align 8
  %47 = call ptr @avra_rc_alloc(i64 32)
  %48 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %47, i64 32, ptr @.i2s_fmt, i64 %positional_idx116)
  %widen117 = sext i32 %48 to i64
  %49 = call i64 @strlen(ptr @.str.102)
  %50 = call i64 @strlen(ptr %47)
  %concat_total118 = add i64 %49, %50
  %concat_size119 = add i64 %concat_total118, 1
  %51 = call ptr @avra_rc_alloc(i64 %concat_size119)
  %52 = call ptr @memcpy(ptr %51, ptr @.str.102, i64 %49)
  %cast120 = ptrtoint ptr %51 to i64
  %dst2_int121 = add i64 %cast120, %49
  %cast122 = inttoptr i64 %dst2_int121 to ptr
  %rhs_len_p1123 = add i64 %50, 1
  %53 = call ptr @memcpy(ptr %cast122, ptr %47, i64 %rhs_len_p1123)
  %fld_ptr124 = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %46, i32 0, i32 0
  store ptr %51, ptr %fld_ptr124, align 8
  %arg125 = load ptr, ptr %arg, align 8
  %fld_ptr126 = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %46, i32 0, i32 1
  store ptr %arg125, ptr %fld_ptr126, align 8
  %cast127 = ptrtoint ptr %46 to i64
  %slot_base128 = ptrtoint ptr %45 to i64
  %slot_addr129 = add i64 %slot_base128, 0
  %slot130 = inttoptr i64 %slot_addr129 to ptr
  %cast131 = inttoptr i64 %cast127 to ptr
  store ptr %cast131, ptr %slot130, align 8
  %parsed_args132 = load ptr, ptr %parsed_args, align 8
  %slot_base133 = ptrtoint ptr %45 to i64
  %slot_addr134 = add i64 %slot_base133, 8
  %slot135 = inttoptr i64 %slot_addr134 to ptr
  store ptr %parsed_args132, ptr %slot135, align 8
  %cast136 = ptrtoint ptr %44 to i64
  %cast137 = inttoptr i64 %cast136 to ptr
  store ptr %cast137, ptr %parsed_args, align 8
  br label %ifcont92
}

define ptr @"@std::cli::strip_dashes"(ptr %0) {
entry:
  %sif_result13 = alloca i64, align 8
  %sif_result = alloca i64, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call i64 @avra_str_starts_with(ptr %s1, ptr @.str.103)
  %sif_cond = icmp ne i64 %1, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %s2 = load ptr, ptr %s, align 8
  %s3 = load ptr, ptr %s, align 8
  %2 = call i64 @strlen(ptr %s3)
  %sub_len = sub i64 %2, 2
  %sub_alloc = add i64 %sub_len, 1
  %3 = call ptr @avra_rc_alloc(i64 %sub_alloc)
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
  %5 = call i64 @avra_str_starts_with(ptr %s8, ptr @.str.104)
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
  %7 = call ptr @avra_rc_alloc(i64 %sub_alloc17)
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

define i1 @"@std::cli::is_flag_match"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @avra_rc_retain(ptr %f)
  store ptr %f, ptr %f5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %f9 = load ptr, ptr %f5, align 8
  %cast = ptrtoint ptr %f9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.105, i64 4, ptr @sty_name.106, i64 18, i64 %null_ext, ptr @src_file.107, i64 101, i64 302)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f9, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %arg10 = load ptr, ptr %arg, align 8
  %2 = call i32 @strcmp(ptr %name, ptr %arg10)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %l_bool = icmp ne i64 %streq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.115, i64 %tag, ptr @mu_file.116, i64 298)
  unreachable

sc_rhs:                                           ; preds = %march_arm2
  %f11 = load ptr, ptr %f5, align 8
  %cast12 = ptrtoint ptr %f11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @avra_null_deref_trap(ptr @fld_name.108, i64 5, ptr @sty_name.109, i64 18, i64 %null_ext14, ptr @src_file.110, i64 101, i64 302)
  %short_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f11, i32 0, i32 1
  %short = load ptr, ptr %short_ptr, align 8
  %3 = call i32 @strcmp(ptr %short, ptr @.str.111)
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
  call void @avra_null_deref_trap(ptr @fld_name.112, i64 5, ptr @sty_name.113, i64 18, i64 %null_ext25, ptr @src_file.114, i64 101, i64 302)
  %short_ptr26 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f22, i32 0, i32 1
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
  %5 = call i1 @"@std::cli::is_flag_match"(ptr %next38, ptr %arg39)
  %widen40 = zext i1 %5 to i64
  store i64 %widen40, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define i1 @"@std::cli::is_option_match"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @avra_rc_retain(ptr %o)
  store ptr %o, ptr %o5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %o9 = load ptr, ptr %o5, align 8
  %cast = ptrtoint ptr %o9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.117, i64 4, ptr @sty_name.118, i64 20, i64 %null_ext, ptr @src_file.119, i64 101, i64 313)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %o9, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %arg10 = load ptr, ptr %arg, align 8
  %2 = call i32 @strcmp(ptr %name, ptr %arg10)
  %widen = sext i32 %2 to i64
  %streq_cmp = icmp eq i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %l_bool = icmp ne i64 %streq_ext, 0
  br i1 %l_bool, label %sc_short, label %sc_rhs

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.127, i64 %tag, ptr @mu_file.128, i64 309)
  unreachable

sc_rhs:                                           ; preds = %march_arm2
  %o11 = load ptr, ptr %o5, align 8
  %cast12 = ptrtoint ptr %o11 to i64
  %null_chk13 = icmp eq i64 %cast12, 0
  %null_ext14 = zext i1 %null_chk13 to i64
  call void @avra_null_deref_trap(ptr @fld_name.120, i64 5, ptr @sty_name.121, i64 20, i64 %null_ext14, ptr @src_file.122, i64 101, i64 313)
  %short_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %o11, i32 0, i32 1
  %short = load ptr, ptr %short_ptr, align 8
  %3 = call i32 @strcmp(ptr %short, ptr @.str.123)
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
  call void @avra_null_deref_trap(ptr @fld_name.124, i64 5, ptr @sty_name.125, i64 20, i64 %null_ext25, ptr @src_file.126, i64 101, i64 313)
  %short_ptr26 = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %o22, i32 0, i32 1
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
  %5 = call i1 @"@std::cli::is_option_match"(ptr %next38, ptr %arg39)
  %widen40 = zext i1 %5 to i64
  store i64 %widen40, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @"@std::cli::arg_at"(ptr %0, i64 %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %args1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %args1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %a_slot_base = ptrtoint ptr %payload to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @avra_rc_retain(ptr %a)
  store ptr %a, ptr %a5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %args1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %idx9 = load i64, ptr %idx, align 8
  %eq = icmp eq i64 %idx9, 0
  %eq_ext = zext i1 %eq to i64
  %sif_cond = icmp ne i64 %eq_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.129, i64 %tag, ptr @mu_file.130, i64 320)
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
  %2 = call ptr @"@std::cli::arg_at"(ptr %next11, i64 %sub)
  %cast13 = ptrtoint ptr %2 to i64
  store i64 %cast13, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @"@std::cli::init_option_defaults"(ptr %0) {
entry:
  %next9 = alloca ptr, align 8
  %o6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %options = alloca ptr, align 8
  store ptr %0, ptr %options, align 8
  %options1 = load ptr, ptr %options, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm3, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast26 = inttoptr i64 %match_val to ptr
  ret ptr %cast26

march_arm:                                        ; preds = %entry
  %1 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %1, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %1, i32 0, i32 1
  store ptr null, ptr %pay_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq5 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq5, label %march_arm3, label %march_next4

march_arm3:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @avra_rc_retain(ptr %o)
  store ptr %o, ptr %o6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %options1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr11 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr11, align 8
  %4 = call ptr @avra_rc_alloc(i64 16)
  %o12 = load ptr, ptr %o6, align 8
  %cast13 = ptrtoint ptr %o12 to i64
  %null_chk = icmp eq i64 %cast13, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.131, i64 4, ptr @sty_name.132, i64 20, i64 %null_ext, ptr @src_file.133, i64 101, i64 334)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %o12, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %5 = call ptr @"@std::cli::strip_dashes"(ptr %name)
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %4, i32 0, i32 0
  store ptr %5, ptr %fld_ptr, align 8
  %o14 = load ptr, ptr %o6, align 8
  %cast15 = ptrtoint ptr %o14 to i64
  %null_chk16 = icmp eq i64 %cast15, 0
  %null_ext17 = zext i1 %null_chk16 to i64
  call void @avra_null_deref_trap(ptr @fld_name.134, i64 11, ptr @sty_name.135, i64 20, i64 %null_ext17, ptr @src_file.136, i64 101, i64 334)
  %default_val_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %o14, i32 0, i32 3
  %default_val = load ptr, ptr %default_val_ptr, align 8
  %fld_ptr18 = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %4, i32 0, i32 1
  store ptr %default_val, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %4 to i64
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast20 = inttoptr i64 %cast19 to ptr
  store ptr %cast20, ptr %slot, align 8
  %next21 = load ptr, ptr %next9, align 8
  %6 = call ptr @"@std::cli::init_option_defaults"(ptr %next21)
  %slot_base22 = ptrtoint ptr %3 to i64
  %slot_addr23 = add i64 %slot_base22, 8
  %slot24 = inttoptr i64 %slot_addr23 to ptr
  store ptr %6, ptr %slot24, align 8
  %cast25 = ptrtoint ptr %2 to i64
  store i64 %cast25, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.137, i64 %tag, ptr @mu_file.138, i64 330)
  unreachable
}

define ptr @"@std::cli::set_option"(ptr %0, ptr %1, ptr %2) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %parsed1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast55 = inttoptr i64 %match_val to ptr
  ret ptr %cast55

march_arm:                                        ; preds = %entry
  %3 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr2 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %3, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr2, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %3, i32 0, i32 1
  %4 = call ptr @avra_rc_alloc(i64 16)
  store ptr %4, ptr %pay_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 16)
  %name3 = load ptr, ptr %name, align 8
  %fld_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %5, i32 0, i32 0
  store ptr %name3, ptr %fld_ptr, align 8
  %value4 = load ptr, ptr %value, align 8
  %fld_ptr5 = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %5, i32 0, i32 1
  store ptr %value4, ptr %fld_ptr5, align 8
  %cast = ptrtoint ptr %5 to i64
  %slot_base = ptrtoint ptr %4 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  %cast6 = inttoptr i64 %cast to ptr
  store ptr %cast6, ptr %slot, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr7 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %6, i32 0, i32 0
  store i64 193455868, ptr %tag_ptr7, align 8
  %pay_ptr8 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %6, i32 0, i32 1
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %parsed1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %po_slot_base = ptrtoint ptr %payload to i64
  %po_slot_addr = add i64 %po_slot_base, 0
  %po_slot = inttoptr i64 %po_slot_addr to ptr
  %po = load ptr, ptr %po_slot, align 8
  call void @avra_rc_retain(ptr %po)
  store ptr %po, ptr %po18, align 8
  %pay_slot19 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %parsed1, i32 0, i32 1
  %payload20 = load ptr, ptr %pay_slot19, align 8
  %next_slot_base = ptrtoint ptr %payload20 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next21, align 8
  %po22 = load ptr, ptr %po18, align 8
  %cast23 = ptrtoint ptr %po22 to i64
  %null_chk = icmp eq i64 %cast23, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.139, i64 4, ptr @sty_name.140, i64 23, i64 %null_ext, ptr @src_file.141, i64 101, i64 347)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %po22, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.142, i64 %tag, ptr @mu_file.143, i64 343)
  unreachable

sif_then:                                         ; preds = %march_arm15
  %8 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr26 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %8, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr26, align 8
  %pay_ptr27 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %8, i32 0, i32 1
  %9 = call ptr @avra_rc_alloc(i64 16)
  store ptr %9, ptr %pay_ptr27, align 8
  %10 = call ptr @avra_rc_alloc(i64 16)
  %name28 = load ptr, ptr %name, align 8
  %fld_ptr29 = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %10, i32 0, i32 0
  store ptr %name28, ptr %fld_ptr29, align 8
  %value30 = load ptr, ptr %value, align 8
  %fld_ptr31 = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %10, i32 0, i32 1
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
  %11 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr42 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %11, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr42, align 8
  %pay_ptr43 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %11, i32 0, i32 1
  %12 = call ptr @avra_rc_alloc(i64 16)
  store ptr %12, ptr %pay_ptr43, align 8
  %po44 = load ptr, ptr %po18, align 8
  %slot_base45 = ptrtoint ptr %12 to i64
  %slot_addr46 = add i64 %slot_base45, 0
  %slot47 = inttoptr i64 %slot_addr46 to ptr
  store ptr %po44, ptr %slot47, align 8
  %next48 = load ptr, ptr %next21, align 8
  %name49 = load ptr, ptr %name, align 8
  %value50 = load ptr, ptr %value, align 8
  %13 = call ptr @"@std::cli::set_option"(ptr %next48, ptr %name49, ptr %value50)
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

define ptr @"@std::cli::merge_flags"(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %f6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %a1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @avra_rc_retain(ptr %f)
  store ptr %f, ptr %f6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %f11 = load ptr, ptr %f6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %f11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @"@std::cli::merge_flags"(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.144, i64 %tag, ptr @mu_file.145, i64 357)
  unreachable
}

define ptr @"@std::cli::merge_options"(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %o6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %a1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @avra_rc_retain(ptr %o)
  store ptr %o, ptr %o6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %o11 = load ptr, ptr %o6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %o11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @"@std::cli::merge_options"(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.146, i64 %tag, ptr @mu_file.147, i64 364)
  unreachable
}

define ptr @"@std::cli::merge_arg_lists"(ptr %0, ptr %1) {
entry:
  %next9 = alloca ptr, align 8
  %arg6 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %a1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %a1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %arg_slot_base = ptrtoint ptr %payload to i64
  %arg_slot_addr = add i64 %arg_slot_base, 0
  %arg_slot = inttoptr i64 %arg_slot_addr to ptr
  %arg = load ptr, ptr %arg_slot, align 8
  call void @avra_rc_retain(ptr %arg)
  store ptr %arg, ptr %arg6, align 8
  %pay_slot7 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %a1, i32 0, i32 1
  %payload8 = load ptr, ptr %pay_slot7, align 8
  %next_slot_base = ptrtoint ptr %payload8 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next9, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %tag_ptr10 = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %2, i32 0, i32 0
  store i64 6384368267, ptr %tag_ptr10, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %2, i32 0, i32 1
  %3 = call ptr @avra_rc_alloc(i64 16)
  store ptr %3, ptr %pay_ptr, align 8
  %arg11 = load ptr, ptr %arg6, align 8
  %slot_base = ptrtoint ptr %3 to i64
  %slot_addr = add i64 %slot_base, 0
  %slot = inttoptr i64 %slot_addr to ptr
  store ptr %arg11, ptr %slot, align 8
  %next12 = load ptr, ptr %next9, align 8
  %b13 = load ptr, ptr %b, align 8
  %4 = call ptr @"@std::cli::merge_arg_lists"(ptr %next12, ptr %b13)
  %slot_base14 = ptrtoint ptr %3 to i64
  %slot_addr15 = add i64 %slot_base14, 8
  %slot16 = inttoptr i64 %slot_addr15 to ptr
  store ptr %4, ptr %slot16, align 8
  %cast17 = ptrtoint ptr %2 to i64
  store i64 %cast17, ptr %match_result, align 8
  br label %match_end

march_next4:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.148, i64 %tag, ptr @mu_file.149, i64 371)
  unreachable
}

define i1 @"@std::cli::result_has_flag"(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.150, i64 5, ptr @sty_name.151, i64 22, i64 %null_ext, ptr @src_file.152, i64 101, i64 380)
  %flags_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %result1, i32 0, i32 1
  %flags = load ptr, ptr %flags_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call i1 @"@std::cli::has_parsed_flag"(ptr %flags, ptr %name2)
  %widen = zext i1 %2 to i64
  %cast3 = trunc i64 %widen to i1
  ret i1 %cast3
}

define i1 @"@std::cli::has_parsed_flag"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %flags1, i32 0, i32 0
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
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %flags1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @avra_rc_retain(ptr %f)
  store ptr %f, ptr %f5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %flags1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %f9 = load ptr, ptr %f5, align 8
  %cast = ptrtoint ptr %f9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.153, i64 4, ptr @sty_name.154, i64 21, i64 %null_ext, ptr @src_file.155, i64 101, i64 388)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlag", ptr %f9, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.159, i64 %tag, ptr @mu_file.160, i64 384)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %f12 = load ptr, ptr %f5, align 8
  %cast13 = ptrtoint ptr %f12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.156, i64 5, ptr @sty_name.157, i64 21, i64 %null_ext15, ptr @src_file.158, i64 101, i64 388)
  %value_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlag", ptr %f12, i32 0, i32 1
  %value = load i1, ptr %value_ptr, align 8
  %cast16 = zext i1 %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call i1 @"@std::cli::has_parsed_flag"(ptr %next17, ptr %name18)
  %widen19 = zext i1 %3 to i64
  store i64 %widen19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @"@std::cli::result_get_option"(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.161, i64 7, ptr @sty_name.162, i64 22, i64 %null_ext, ptr @src_file.163, i64 101, i64 394)
  %options_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %result1, i32 0, i32 2
  %options = load ptr, ptr %options_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call ptr @"@std::cli::get_parsed_option"(ptr %options, ptr %name2)
  ret ptr %2
}

define ptr @"@std::cli::get_parsed_option"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %options1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.164 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %options1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %o_slot_base = ptrtoint ptr %payload to i64
  %o_slot_addr = add i64 %o_slot_base, 0
  %o_slot = inttoptr i64 %o_slot_addr to ptr
  %o = load ptr, ptr %o_slot, align 8
  call void @avra_rc_retain(ptr %o)
  store ptr %o, ptr %o5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %options1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %o9 = load ptr, ptr %o5, align 8
  %cast = ptrtoint ptr %o9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.165, i64 4, ptr @sty_name.166, i64 23, i64 %null_ext, ptr @src_file.167, i64 101, i64 402)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %o9, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.171, i64 %tag, ptr @mu_file.172, i64 398)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %o12 = load ptr, ptr %o5, align 8
  %cast13 = ptrtoint ptr %o12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.168, i64 5, ptr @sty_name.169, i64 23, i64 %null_ext15, ptr @src_file.170, i64 101, i64 402)
  %value_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %o12, i32 0, i32 1
  %value = load ptr, ptr %value_ptr, align 8
  %cast16 = ptrtoint ptr %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call ptr @"@std::cli::get_parsed_option"(ptr %next17, ptr %name18)
  %cast19 = ptrtoint ptr %3 to i64
  store i64 %cast19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define ptr @"@std::cli::result_get_arg"(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  store ptr %1, ptr %name, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.173, i64 4, ptr @sty_name.174, i64 22, i64 %null_ext, ptr @src_file.175, i64 101, i64 408)
  %args_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %result1, i32 0, i32 3
  %args = load ptr, ptr %args_ptr, align 8
  %name2 = load ptr, ptr %name, align 8
  %2 = call ptr @"@std::cli::get_parsed_arg"(ptr %args, ptr %name2)
  ret ptr %2
}

define ptr @"@std::cli::get_parsed_arg"(ptr %0, ptr %1) {
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
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %args1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %sif_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  %cast20 = inttoptr i64 %match_val to ptr
  ret ptr %cast20

march_arm:                                        ; preds = %entry
  store i64 ptrtoint (ptr @.str.176 to i64), ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %args1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %a_slot_base = ptrtoint ptr %payload to i64
  %a_slot_addr = add i64 %a_slot_base, 0
  %a_slot = inttoptr i64 %a_slot_addr to ptr
  %a = load ptr, ptr %a_slot, align 8
  call void @avra_rc_retain(ptr %a)
  store ptr %a, ptr %a5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %args1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %a9 = load ptr, ptr %a5, align 8
  %cast = ptrtoint ptr %a9 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.177, i64 4, ptr @sty_name.178, i64 20, i64 %null_ext, ptr @src_file.179, i64 101, i64 416)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %a9, i32 0, i32 0
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
  call void @avra_match_unreachable(ptr @.match_fn.183, i64 %tag, ptr @mu_file.184, i64 412)
  unreachable

sif_then:                                         ; preds = %march_arm2
  %a12 = load ptr, ptr %a5, align 8
  %cast13 = ptrtoint ptr %a12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.180, i64 5, ptr @sty_name.181, i64 20, i64 %null_ext15, ptr @src_file.182, i64 101, i64 416)
  %value_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %a12, i32 0, i32 1
  %value = load ptr, ptr %value_ptr, align 8
  %cast16 = ptrtoint ptr %value to i64
  store i64 %cast16, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %march_arm2
  %next17 = load ptr, ptr %next8, align 8
  %name18 = load ptr, ptr %name, align 8
  %3 = call ptr @"@std::cli::get_parsed_arg"(ptr %next17, ptr %name18)
  %cast19 = ptrtoint ptr %3 to i64
  store i64 %cast19, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  store i64 %sif_val, ptr %match_result, align 8
  br label %match_end
}

define i1 @"@std::cli::result_has_error"(ptr %0) {
entry:
  %result = alloca ptr, align 8
  store ptr %0, ptr %result, align 8
  %result1 = load ptr, ptr %result, align 8
  %cast = ptrtoint ptr %result1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.185, i64 5, ptr @sty_name.186, i64 22, i64 %null_ext, ptr @src_file.187, i64 101, i64 422)
  %error_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %result1, i32 0, i32 4
  %error = load ptr, ptr %error_ptr, align 8
  %1 = call i32 @strcmp(ptr %error, ptr @.str.188)
  %widen = sext i32 %1 to i64
  %streq_cmp = icmp ne i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %cast2 = trunc i64 %streq_ext to i1
  ret i1 %cast2
}

define i64 @"@std::cli::cli_print_help"(ptr %0) {
entry:
  %cli = alloca ptr, align 8
  store ptr %0, ptr %cli, align 8
  %cli1 = load ptr, ptr %cli, align 8
  %cast = ptrtoint ptr %cli1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.189, i64 4, ptr @sty_name.190, i64 14, i64 %null_ext, ptr @src_file.191, i64 101, i64 428)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr %name)
  %2 = call i64 @strlen(ptr @.str.192)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr %name, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr @.str.192, i64 %rhs_len_p1)
  %cli4 = load ptr, ptr %cli, align 8
  %cast5 = ptrtoint ptr %cli4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.193, i64 7, ptr @sty_name.194, i64 14, i64 %null_ext7, ptr @src_file.195, i64 101, i64 428)
  %version_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli4, i32 0, i32 2
  %version = load ptr, ptr %version_ptr, align 8
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr %version)
  %concat_total8 = add i64 %6, %7
  %concat_size9 = add i64 %concat_total8, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast10 = ptrtoint ptr %8 to i64
  %dst2_int11 = add i64 %cast10, %6
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast12, ptr %version, i64 %rhs_len_p113)
  %11 = call i32 @puts(ptr %8)
  %widen = sext i32 %11 to i64
  %cli14 = load ptr, ptr %cli, align 8
  %cast15 = ptrtoint ptr %cli14 to i64
  %null_chk16 = icmp eq i64 %cast15, 0
  %null_ext17 = zext i1 %null_chk16 to i64
  call void @avra_null_deref_trap(ptr @fld_name.196, i64 11, ptr @sty_name.197, i64 14, i64 %null_ext17, ptr @src_file.198, i64 101, i64 429)
  %description_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli14, i32 0, i32 1
  %description = load ptr, ptr %description_ptr, align 8
  %12 = call i32 @strcmp(ptr %description, ptr @.str.199)
  %widen18 = sext i32 %12 to i64
  %streq_cmp = icmp ne i64 %widen18, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

ifcont:                                           ; preds = %if_else, %if_then
  %13 = call i32 @puts(ptr @.str.203)
  %widen26 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr @.str.204)
  %widen27 = sext i32 %14 to i64
  %cli28 = load ptr, ptr %cli, align 8
  %cast29 = ptrtoint ptr %cli28 to i64
  %null_chk30 = icmp eq i64 %cast29, 0
  %null_ext31 = zext i1 %null_chk30 to i64
  call void @avra_null_deref_trap(ptr @fld_name.206, i64 4, ptr @sty_name.207, i64 14, i64 %null_ext31, ptr @src_file.208, i64 101, i64 434)
  %name_ptr32 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli28, i32 0, i32 0
  %name33 = load ptr, ptr %name_ptr32, align 8
  %15 = call i64 @strlen(ptr @.str.205)
  %16 = call i64 @strlen(ptr %name33)
  %concat_total34 = add i64 %15, %16
  %concat_size35 = add i64 %concat_total34, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size35)
  %18 = call ptr @memcpy(ptr %17, ptr @.str.205, i64 %15)
  %cast36 = ptrtoint ptr %17 to i64
  %dst2_int37 = add i64 %cast36, %15
  %cast38 = inttoptr i64 %dst2_int37 to ptr
  %rhs_len_p139 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast38, ptr %name33, i64 %rhs_len_p139)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.209)
  %concat_total40 = add i64 %20, %21
  %concat_size41 = add i64 %concat_total40, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size41)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast42 = ptrtoint ptr %22 to i64
  %dst2_int43 = add i64 %cast42, %20
  %cast44 = inttoptr i64 %dst2_int43 to ptr
  %rhs_len_p145 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast44, ptr @.str.209, i64 %rhs_len_p145)
  %25 = call i32 @puts(ptr %22)
  %widen46 = sext i32 %25 to i64
  %26 = call i32 @puts(ptr @.str.210)
  %widen47 = sext i32 %26 to i64
  %cli48 = load ptr, ptr %cli, align 8
  %cast49 = ptrtoint ptr %cli48 to i64
  %null_chk50 = icmp eq i64 %cast49, 0
  %null_ext51 = zext i1 %null_chk50 to i64
  call void @avra_null_deref_trap(ptr @fld_name.211, i64 8, ptr @sty_name.212, i64 14, i64 %null_ext51, ptr @src_file.213, i64 101, i64 436)
  %commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli48, i32 0, i32 3
  %commands = load ptr, ptr %commands_ptr, align 8
  %27 = call i64 @"@std::cli::print_commands"(ptr %commands)
  %cli52 = load ptr, ptr %cli, align 8
  %cast53 = ptrtoint ptr %cli52 to i64
  %null_chk54 = icmp eq i64 %cast53, 0
  %null_ext55 = zext i1 %null_chk54 to i64
  call void @avra_null_deref_trap(ptr @fld_name.215, i64 5, ptr @sty_name.216, i64 14, i64 %null_ext55, ptr @src_file.217, i64 101, i64 437)
  %flags_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli52, i32 0, i32 4
  %flags = load ptr, ptr %flags_ptr, align 8
  %28 = call i64 @"@std::cli::print_flags"(ptr @.str.214, ptr %flags)
  ret i64 %28

if_then:                                          ; preds = %entry
  %cli19 = load ptr, ptr %cli, align 8
  %cast20 = ptrtoint ptr %cli19 to i64
  %null_chk21 = icmp eq i64 %cast20, 0
  %null_ext22 = zext i1 %null_chk21 to i64
  call void @avra_null_deref_trap(ptr @fld_name.200, i64 11, ptr @sty_name.201, i64 14, i64 %null_ext22, ptr @src_file.202, i64 101, i64 430)
  %description_ptr23 = getelementptr inbounds nuw %"@std::cli::Cli", ptr %cli19, i32 0, i32 1
  %description24 = load ptr, ptr %description_ptr23, align 8
  %29 = call i32 @puts(ptr %description24)
  %widen25 = sext i32 %29 to i64
  br label %ifcont

if_else:                                          ; preds = %entry
  br label %ifcont
}

define i64 @"@std::cli::print_commands"(ptr %0) {
entry:
  %next8 = alloca ptr, align 8
  %cmd5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %cmds = alloca ptr, align 8
  store ptr %0, ptr %cmds, align 8
  %cmds1 = load ptr, ptr %cmds, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %march_arm2, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %1 = call ptr @avra_map_new_cstr()
  %cast = ptrtoint ptr %1 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %cmd_slot_base = ptrtoint ptr %payload to i64
  %cmd_slot_addr = add i64 %cmd_slot_base, 0
  %cmd_slot = inttoptr i64 %cmd_slot_addr to ptr
  %cmd = load ptr, ptr %cmd_slot, align 8
  call void @avra_rc_retain(ptr %cmd)
  store ptr %cmd, ptr %cmd5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %cmds1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %next9 = load ptr, ptr %next8, align 8
  %2 = call i64 @"@std::cli::print_commands"(ptr %next9)
  %cmd10 = load ptr, ptr %cmd5, align 8
  %cast11 = ptrtoint ptr %cmd10 to i64
  %null_chk = icmp eq i64 %cast11, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.219, i64 4, ptr @sty_name.220, i64 21, i64 %null_ext, ptr @src_file.221, i64 101, i64 448)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd10, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %3 = call i64 @strlen(ptr @.str.218)
  %4 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str.218, i64 %3)
  %cast12 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast12, %3
  %cast13 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast13, ptr %name, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.222)
  %concat_total14 = add i64 %8, %9
  %concat_size15 = add i64 %concat_total14, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast16 = ptrtoint ptr %10 to i64
  %dst2_int17 = add i64 %cast16, %8
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast18, ptr @.str.222, i64 %rhs_len_p119)
  %cmd20 = load ptr, ptr %cmd5, align 8
  %cast21 = ptrtoint ptr %cmd20 to i64
  %null_chk22 = icmp eq i64 %cast21, 0
  %null_ext23 = zext i1 %null_chk22 to i64
  call void @avra_null_deref_trap(ptr @fld_name.223, i64 11, ptr @sty_name.224, i64 21, i64 %null_ext23, ptr @src_file.225, i64 101, i64 448)
  %description_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %cmd20, i32 0, i32 1
  %description = load ptr, ptr %description_ptr, align 8
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr %description)
  %concat_total24 = add i64 %13, %14
  %concat_size25 = add i64 %concat_total24, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size25)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast26 = ptrtoint ptr %15 to i64
  %dst2_int27 = add i64 %cast26, %13
  %cast28 = inttoptr i64 %dst2_int27 to ptr
  %rhs_len_p129 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast28, ptr %description, i64 %rhs_len_p129)
  %18 = call i32 @puts(ptr %15)
  %widen = sext i32 %18 to i64
  store i64 0, ptr %match_result, align 8
  br label %match_end

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.226, i64 %tag, ptr @mu_file.227, i64 441)
  unreachable
}

define i64 @"@std::cli::print_flags"(ptr %0, ptr %1) {
entry:
  %short_str = alloca ptr, align 8
  %ife_result = alloca i64, align 8
  %next8 = alloca ptr, align 8
  %f5 = alloca ptr, align 8
  %match_result = alloca i64, align 8
  %flags = alloca ptr, align 8
  %header = alloca ptr, align 8
  store ptr %0, ptr %header, align 8
  store ptr %1, ptr %flags, align 8
  %flags1 = load ptr, ptr %flags, align 8
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  store i64 0, ptr %match_result, align 8
  %tag_eq = icmp eq i64 %tag, 193455868
  br i1 %tag_eq, label %march_arm, label %march_next

match_end:                                        ; preds = %ife_end, %march_arm
  %match_val = load i64, ptr %match_result, align 8
  ret i64 %match_val

march_arm:                                        ; preds = %entry
  %2 = call ptr @avra_map_new_cstr()
  %cast = ptrtoint ptr %2 to i64
  store i64 %cast, ptr %match_result, align 8
  br label %match_end

march_next:                                       ; preds = %entry
  %tag_eq4 = icmp eq i64 %tag, 6384368267
  br i1 %tag_eq4, label %march_arm2, label %march_next3

march_arm2:                                       ; preds = %march_next
  %pay_slot = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 1
  %payload = load ptr, ptr %pay_slot, align 8
  %f_slot_base = ptrtoint ptr %payload to i64
  %f_slot_addr = add i64 %f_slot_base, 0
  %f_slot = inttoptr i64 %f_slot_addr to ptr
  %f = load ptr, ptr %f_slot, align 8
  call void @avra_rc_retain(ptr %f)
  store ptr %f, ptr %f5, align 8
  %pay_slot6 = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %flags1, i32 0, i32 1
  %payload7 = load ptr, ptr %pay_slot6, align 8
  %next_slot_base = ptrtoint ptr %payload7 to i64
  %next_slot_addr = add i64 %next_slot_base, 8
  %next_slot = inttoptr i64 %next_slot_addr to ptr
  %next = load ptr, ptr %next_slot, align 8
  call void @avra_rc_retain(ptr %next)
  store ptr %next, ptr %next8, align 8
  %header9 = load ptr, ptr %header, align 8
  %3 = call i32 @strcmp(ptr %header9, ptr @.str.228)
  %widen = sext i32 %3 to i64
  %streq_cmp = icmp ne i64 %widen, 0
  %streq_ext = zext i1 %streq_cmp to i64
  %if_cond = icmp ne i64 %streq_ext, 0
  br i1 %if_cond, label %if_then, label %if_else

march_next3:                                      ; preds = %march_next
  call void @avra_match_unreachable(ptr @.match_fn.248, i64 %tag, ptr @mu_file.249, i64 454)
  unreachable

ifcont:                                           ; preds = %if_else, %if_then
  %f13 = load ptr, ptr %f5, align 8
  %cast14 = ptrtoint ptr %f13 to i64
  %null_chk = icmp eq i64 %cast14, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.230, i64 5, ptr @sty_name.231, i64 18, i64 %null_ext, ptr @src_file.232, i64 101, i64 462)
  %short_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f13, i32 0, i32 1
  %short = load ptr, ptr %short_ptr, align 8
  %4 = call i32 @strcmp(ptr %short, ptr @.str.233)
  %widen15 = sext i32 %4 to i64
  %streq_cmp16 = icmp ne i64 %widen15, 0
  %streq_ext17 = zext i1 %streq_cmp16 to i64
  %ife_cond = icmp ne i64 %streq_ext17, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

if_then:                                          ; preds = %march_arm2
  %5 = call i32 @puts(ptr @.str.229)
  %widen10 = sext i32 %5 to i64
  %header11 = load ptr, ptr %header, align 8
  %6 = call i32 @puts(ptr %header11)
  %widen12 = sext i32 %6 to i64
  br label %ifcont

if_else:                                          ; preds = %march_arm2
  br label %ifcont

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %cast27 = inttoptr i64 %ife_val to ptr
  store ptr %cast27, ptr %short_str, align 8
  %f28 = load ptr, ptr %f5, align 8
  %cast29 = ptrtoint ptr %f28 to i64
  %null_chk30 = icmp eq i64 %cast29, 0
  %null_ext31 = zext i1 %null_chk30 to i64
  call void @avra_null_deref_trap(ptr @fld_name.240, i64 4, ptr @sty_name.241, i64 18, i64 %null_ext31, ptr @src_file.242, i64 101, i64 463)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f28, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %7 = call i64 @strlen(ptr @.str.239)
  %8 = call i64 @strlen(ptr %name)
  %concat_total32 = add i64 %7, %8
  %concat_size33 = add i64 %concat_total32, 1
  %9 = call ptr @avra_rc_alloc(i64 %concat_size33)
  %10 = call ptr @memcpy(ptr %9, ptr @.str.239, i64 %7)
  %cast34 = ptrtoint ptr %9 to i64
  %dst2_int35 = add i64 %cast34, %7
  %cast36 = inttoptr i64 %dst2_int35 to ptr
  %rhs_len_p137 = add i64 %8, 1
  %11 = call ptr @memcpy(ptr %cast36, ptr %name, i64 %rhs_len_p137)
  %short_str38 = load ptr, ptr %short_str, align 8
  %12 = call i64 @strlen(ptr %9)
  %13 = call i64 @strlen(ptr %short_str38)
  %concat_total39 = add i64 %12, %13
  %concat_size40 = add i64 %concat_total39, 1
  %14 = call ptr @avra_rc_alloc(i64 %concat_size40)
  %15 = call ptr @memcpy(ptr %14, ptr %9, i64 %12)
  %cast41 = ptrtoint ptr %14 to i64
  %dst2_int42 = add i64 %cast41, %12
  %cast43 = inttoptr i64 %dst2_int42 to ptr
  %rhs_len_p144 = add i64 %13, 1
  %16 = call ptr @memcpy(ptr %cast43, ptr %short_str38, i64 %rhs_len_p144)
  %17 = call i64 @strlen(ptr %14)
  %18 = call i64 @strlen(ptr @.str.243)
  %concat_total45 = add i64 %17, %18
  %concat_size46 = add i64 %concat_total45, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size46)
  %20 = call ptr @memcpy(ptr %19, ptr %14, i64 %17)
  %cast47 = ptrtoint ptr %19 to i64
  %dst2_int48 = add i64 %cast47, %17
  %cast49 = inttoptr i64 %dst2_int48 to ptr
  %rhs_len_p150 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast49, ptr @.str.243, i64 %rhs_len_p150)
  %f51 = load ptr, ptr %f5, align 8
  %cast52 = ptrtoint ptr %f51 to i64
  %null_chk53 = icmp eq i64 %cast52, 0
  %null_ext54 = zext i1 %null_chk53 to i64
  call void @avra_null_deref_trap(ptr @fld_name.244, i64 11, ptr @sty_name.245, i64 18, i64 %null_ext54, ptr @src_file.246, i64 101, i64 463)
  %description_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f51, i32 0, i32 2
  %description = load ptr, ptr %description_ptr, align 8
  %22 = call i64 @strlen(ptr %19)
  %23 = call i64 @strlen(ptr %description)
  %concat_total55 = add i64 %22, %23
  %concat_size56 = add i64 %concat_total55, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size56)
  %25 = call ptr @memcpy(ptr %24, ptr %19, i64 %22)
  %cast57 = ptrtoint ptr %24 to i64
  %dst2_int58 = add i64 %cast57, %22
  %cast59 = inttoptr i64 %dst2_int58 to ptr
  %rhs_len_p160 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast59, ptr %description, i64 %rhs_len_p160)
  %27 = call i32 @puts(ptr %24)
  %widen61 = sext i32 %27 to i64
  %next62 = load ptr, ptr %next8, align 8
  %28 = call i64 @"@std::cli::print_flags"(ptr @.str.247, ptr %next62)
  store i64 %28, ptr %match_result, align 8
  br label %match_end

ife_then:                                         ; preds = %ifcont
  %f18 = load ptr, ptr %f5, align 8
  %cast19 = ptrtoint ptr %f18 to i64
  %null_chk20 = icmp eq i64 %cast19, 0
  %null_ext21 = zext i1 %null_chk20 to i64
  call void @avra_null_deref_trap(ptr @fld_name.235, i64 5, ptr @sty_name.236, i64 18, i64 %null_ext21, ptr @src_file.237, i64 101, i64 462)
  %short_ptr22 = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %f18, i32 0, i32 1
  %short23 = load ptr, ptr %short_ptr22, align 8
  %29 = call i64 @strlen(ptr @.str.234)
  %30 = call i64 @strlen(ptr %short23)
  %concat_total = add i64 %29, %30
  %concat_size = add i64 %concat_total, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.234, i64 %29)
  %cast24 = ptrtoint ptr %31 to i64
  %dst2_int = add i64 %cast24, %29
  %cast25 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast25, ptr %short23, i64 %rhs_len_p1)
  %cast26 = ptrtoint ptr %31 to i64
  store i64 %cast26, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %ifcont
  store i64 ptrtoint (ptr @.str.238 to i64), ptr %ife_result, align 8
  br label %ife_end
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %c = alloca ptr, align 8
  %1 = call ptr @"@std::cli::cli_new"(ptr @.str.250, ptr @.str.251, ptr @.str.252)
  store ptr %1, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %cast = ptrtoint ptr %c1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.253, i64 4, ptr @sty_name.254, i64 14, i64 %null_ext, ptr @src_file.255, i64 101, i64 6)
  %name_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %c1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %2 = call i32 @puts(ptr %name)
  %widen = sext i32 %2 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  %0 = call i64 @"__init_@std"()
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @"__release_@std::cli::Cli"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_args_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  %rel_version_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 2
  %rel_version = load ptr, ptr %rel_version_ptr, align 8
  %is_null_version = icmp eq ptr %rel_version, null
  br i1 %is_null_version, label %rel_version_skip, label %rel_version_do

rel_description_do:                               ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_version_skip:                                 ; preds = %rel_version_do, %rel_description_skip
  %rel_commands_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 3
  %rel_commands = load ptr, ptr %rel_commands_ptr, align 8
  %is_null_commands = icmp eq ptr %rel_commands, null
  br i1 %is_null_commands, label %rel_commands_skip, label %rel_commands_do

rel_version_do:                                   ; preds = %rel_description_skip
  call void @avra_rc_release(ptr %rel_version)
  br label %rel_version_skip

rel_commands_skip:                                ; preds = %rel_commands_do, %rel_version_skip
  %rel_flags_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 4
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_commands_do:                                  ; preds = %rel_version_skip
  %2 = call i64 @"__release_@std::cli::CommandList"(ptr %rel_commands)
  br label %rel_commands_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_commands_skip
  %rel_options_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 5
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_commands_skip
  %3 = call i64 @"__release_@std::cli::FlagList"(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %"@std::cli::Cli", ptr %0, i32 0, i32 6
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %4 = call i64 @"__release_@std::cli::OptionList"(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_args_do:                                      ; preds = %rel_options_skip
  %5 = call i64 @"__release_@std::cli::ArgList"(ptr %rel_args)
  br label %rel_args_skip
}

define i64 @"__release_@std::cli::ParseResult"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_command_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %0, i32 0, i32 0
  %rel_command = load ptr, ptr %rel_command_ptr, align 8
  %is_null_command = icmp eq ptr %rel_command, null
  br i1 %is_null_command, label %rel_command_skip, label %rel_command_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_error_skip
  ret i64 0

rel_command_skip:                                 ; preds = %rel_command_do, %do_free
  %rel_flags_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %0, i32 0, i32 1
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_command_do:                                   ; preds = %do_free
  call void @avra_rc_release(ptr %rel_command)
  br label %rel_command_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_command_skip
  %rel_options_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %0, i32 0, i32 2
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_command_skip
  %2 = call i64 @"__release_@std::cli::ParsedFlagList"(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %0, i32 0, i32 3
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %3 = call i64 @"__release_@std::cli::ParsedOptionList"(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  %rel_error_ptr = getelementptr inbounds nuw %"@std::cli::ParseResult", ptr %0, i32 0, i32 4
  %rel_error = load ptr, ptr %rel_error_ptr, align 8
  %is_null_error = icmp eq ptr %rel_error, null
  br i1 %is_null_error, label %rel_error_skip, label %rel_error_do

rel_args_do:                                      ; preds = %rel_options_skip
  %4 = call i64 @"__release_@std::cli::ParsedArgList"(ptr %rel_args)
  br label %rel_args_skip

rel_error_skip:                                   ; preds = %rel_error_do, %rel_args_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_error_do:                                     ; preds = %rel_args_skip
  call void @avra_rc_release(ptr %rel_error)
  br label %rel_error_skip
}

define i64 @"__release_@std::cli::ParsedArg"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_value_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_value_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArg", ptr %0, i32 0, i32 1
  %rel_value = load ptr, ptr %rel_value_ptr, align 8
  %is_null_value = icmp eq ptr %rel_value, null
  br i1 %is_null_value, label %rel_value_skip, label %rel_value_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_value_skip:                                   ; preds = %rel_value_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_value_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_value)
  br label %rel_value_skip
}

define i64 @"__release_@std::cli::ParsedOption"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_value_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_value_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOption", ptr %0, i32 0, i32 1
  %rel_value = load ptr, ptr %rel_value_ptr, align 8
  %is_null_value = icmp eq ptr %rel_value, null
  br i1 %is_null_value, label %rel_value_skip, label %rel_value_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_value_skip:                                   ; preds = %rel_value_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_value_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_value)
  br label %rel_value_skip
}

define i64 @"__release_@std::cli::ParsedFlag"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlag", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}

define i64 @"__release_@std::cli::CommandDef"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_args_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  %rel_flags_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %0, i32 0, i32 2
  %rel_flags = load ptr, ptr %rel_flags_ptr, align 8
  %is_null_flags = icmp eq ptr %rel_flags, null
  br i1 %is_null_flags, label %rel_flags_skip, label %rel_flags_do

rel_description_do:                               ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_flags_skip:                                   ; preds = %rel_flags_do, %rel_description_skip
  %rel_options_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %0, i32 0, i32 3
  %rel_options = load ptr, ptr %rel_options_ptr, align 8
  %is_null_options = icmp eq ptr %rel_options, null
  br i1 %is_null_options, label %rel_options_skip, label %rel_options_do

rel_flags_do:                                     ; preds = %rel_description_skip
  %2 = call i64 @"__release_@std::cli::FlagList"(ptr %rel_flags)
  br label %rel_flags_skip

rel_options_skip:                                 ; preds = %rel_options_do, %rel_flags_skip
  %rel_args_ptr = getelementptr inbounds nuw %"@std::cli::CommandDef", ptr %0, i32 0, i32 4
  %rel_args = load ptr, ptr %rel_args_ptr, align 8
  %is_null_args = icmp eq ptr %rel_args, null
  br i1 %is_null_args, label %rel_args_skip, label %rel_args_do

rel_options_do:                                   ; preds = %rel_flags_skip
  %3 = call i64 @"__release_@std::cli::OptionList"(ptr %rel_options)
  br label %rel_options_skip

rel_args_skip:                                    ; preds = %rel_args_do, %rel_options_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_args_do:                                      ; preds = %rel_options_skip
  %4 = call i64 @"__release_@std::cli::ArgList"(ptr %rel_args)
  br label %rel_args_skip
}

define i64 @"__release_@std::cli::ArgDef"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_description_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_description_ptr = getelementptr inbounds nuw %"@std::cli::ArgDef", ptr %0, i32 0, i32 1
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_description_do:                               ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip
}

define i64 @"__release_@std::cli::OptionDef"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_default_val_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_short_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %0, i32 0, i32 1
  %rel_short = load ptr, ptr %rel_short_ptr, align 8
  %is_null_short = icmp eq ptr %rel_short, null
  br i1 %is_null_short, label %rel_short_skip, label %rel_short_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_short_skip:                                   ; preds = %rel_short_do, %rel_name_skip
  %rel_description_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %0, i32 0, i32 2
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_short_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_short)
  br label %rel_short_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_short_skip
  %rel_default_val_ptr = getelementptr inbounds nuw %"@std::cli::OptionDef", ptr %0, i32 0, i32 3
  %rel_default_val = load ptr, ptr %rel_default_val_ptr, align 8
  %is_null_default_val = icmp eq ptr %rel_default_val, null
  br i1 %is_null_default_val, label %rel_default_val_skip, label %rel_default_val_do

rel_description_do:                               ; preds = %rel_short_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip

rel_default_val_skip:                             ; preds = %rel_default_val_do, %rel_description_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_default_val_do:                               ; preds = %rel_description_skip
  call void @avra_rc_release(ptr %rel_default_val)
  br label %rel_default_val_skip
}

define i64 @"__release_@std::cli::FlagDef"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_description_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_short_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %0, i32 0, i32 1
  %rel_short = load ptr, ptr %rel_short_ptr, align 8
  %is_null_short = icmp eq ptr %rel_short, null
  br i1 %is_null_short, label %rel_short_skip, label %rel_short_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_short_skip:                                   ; preds = %rel_short_do, %rel_name_skip
  %rel_description_ptr = getelementptr inbounds nuw %"@std::cli::FlagDef", ptr %0, i32 0, i32 2
  %rel_description = load ptr, ptr %rel_description_ptr, align 8
  %is_null_description = icmp eq ptr %rel_description, null
  br i1 %is_null_description, label %rel_description_skip, label %rel_description_do

rel_short_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_short)
  br label %rel_short_skip

rel_description_skip:                             ; preds = %rel_description_do, %rel_short_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_description_do:                               ; preds = %rel_short_skip
  call void @avra_rc_release(ptr %rel_description)
  br label %rel_description_skip
}

define i64 @"__release_@std::cli::ParsedArgList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArgList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArgList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::ParsedArgList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::ParsedArg"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::ParsedArgList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::ParsedOptionList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::ParsedOptionList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::ParsedOption"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::ParsedOptionList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::ParsedFlagList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::ParsedFlagList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::ParsedFlag"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::ParsedFlagList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::CommandList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::CommandList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::CommandList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::CommandList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::CommandDef"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::CommandList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::ArgList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::ArgList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::ArgList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::ArgList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::ArgDef"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::ArgList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::OptionList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::OptionList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::OptionList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::OptionList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::OptionDef"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::OptionList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__release_@std::cli::FlagList"(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %tag_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %0, i32 0, i32 0
  %tag = load i64, ptr %tag_ptr, align 8
  %pay_ptr = getelementptr inbounds nuw %"@std::cli::FlagList", ptr %0, i32 0, i32 1
  %payload = load ptr, ptr %pay_ptr, align 8
  %is_Node = icmp eq i64 %tag, 6384368267
  br i1 %is_Node, label %rel_Node, label %try_next_Node

alive:                                            ; preds = %entry
  call void @avra_rc_suspect(ptr %0)
  br label %done

done:                                             ; preds = %alive, %fields_done
  ret i64 0

fields_done:                                      ; preds = %try_next_Node, %vrel_next_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_Node:                                         ; preds = %do_free
  %vrel_item_ptr = getelementptr inbounds nuw %"@std::cli::FlagList__Node", ptr %payload, i32 0, i32 0
  %vrel_item = load ptr, ptr %vrel_item_ptr, align 8
  %vrel_null_item = icmp eq ptr %vrel_item, null
  br i1 %vrel_null_item, label %vrel_item_skip, label %vrel_item_do

try_next_Node:                                    ; preds = %do_free
  br label %fields_done

vrel_item_skip:                                   ; preds = %vrel_item_do, %rel_Node
  %vrel_next_ptr = getelementptr inbounds nuw %"@std::cli::FlagList__Node", ptr %payload, i32 0, i32 1
  %vrel_next = load ptr, ptr %vrel_next_ptr, align 8
  %vrel_null_next = icmp eq ptr %vrel_next, null
  br i1 %vrel_null_next, label %vrel_next_skip, label %vrel_next_do

vrel_item_do:                                     ; preds = %rel_Node
  %2 = call i64 @"__release_@std::cli::FlagDef"(ptr %vrel_item)
  br label %vrel_item_skip

vrel_next_skip:                                   ; preds = %vrel_next_do, %vrel_item_skip
  br label %fields_done

vrel_next_do:                                     ; preds = %vrel_item_skip
  %3 = call i64 @"__release_@std::cli::FlagList"(ptr %vrel_next)
  br label %vrel_next_skip
}

define i64 @"__init_@std"() {
entry:
  %0 = call i64 @__init_cli()
  call void @avra_test_flush()
  ret i64 0
}

define i64 @__init_cli() {
entry:
  call void @avra_test_flush()
  ret i64 0
}
