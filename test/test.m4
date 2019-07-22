m4_include(cmacros.m4)m4_dnl
m4_addsubst("` ONE '","`one_code,'")m4_dnl
m4_addsubst("` TWO '","`two_code,'")m4_dnl
m4_addsubst("` THREE '","`three_code,'")m4_dnl
m4_addsubst("` FOUR '","`four_code,'")m4_dnl
m4_addsubst("` , '","`comma_code,'")m4_dnl

m4_forth2m4(("`: #TEST, ( test ) ONE IF TWO , ELSE BEGIN THREE WHILE FOUR REPEAT THEN ;'"))

m4_forth2c(("`: #TEST, ( test ) ONE IF TWO , ELSE BEGIN THREE WHILE FOUR REPEAT THEN ;'"))

