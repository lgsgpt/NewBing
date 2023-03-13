cls,clear
use "D:\文档\L\认知\CLHLS 2018.dta",clear

//问题C1-6，记为0-7分，其中超过7个记为7分。donnot know, missing, .记为0分
gen cog16 = c16
recode cog16 88 99 . = 0
replace cog16 = 7 if cog16 > 7
tab cog16

gen cog11 = c11
recode cog11 8 9 . = 0

gen cog12 = c12
recode cog12 8 . = 0

gen cog13 = c13
recode cog13 8 9 . = 0

gen cog14 = c14
recode cog14 8 . = 0

gen cog15 = c15
recode cog15 8 . = 0

gen cog21a = c21a
recode cog21a 8 9 . = 0

gen cog21b = c21b
recode cog21b 8 . = 0

gen cog21c = c21c
recode cog21c 8 . = 0

gen cog31a = c31a
recode cog31a 8 . = 0

gen cog31b = c31b
recode cog31b 8 . = 0

gen cog31c = c31c
recode cog31c 8 9 . = 0

gen cog31d = c31d
recode cog31d 8 . = 0

gen cog31e = c31e
recode cog31e 8 9 . = 0

/**************
* 待定
*/
gen _cog32 = c32
recode _cog32 8 9 . = 0

gen cog41a = c41a
recode cog41a 8 9 . = 0

gen cog41b = c41b
recode cog41b 8 . = 0

gen cog41c = c41c
recode cog41c 8 . = 0

gen cog51a = c51a
recode cog51a 8 9 . = 0

gen cog51b = c51b
recode cog51b 8 9 . = 0

gen cog52 = c52
recode cog52 8 . = 0

gen cog53a = c53a
recode cog53a 8 . = 0

gen cog53b = c53b
recode cog53b 8 . = 0

gen cog53c = c53c
recode cog53c 8 9 . = 0


generate cognition = cog11 + cog12 + cog13 + cog14 + cog15 + cog16 + ///
cog21a + cog21b + cog21c + cog31a + cog31b + cog31c + cog31d + cog31e + ///
_cog32 + cog41a + cog41b + cog41c + cog51a + cog51b + cog52 + cog53a + cog53b + cog53c

replace cognition = 0 if cognition >= 0 & cognition <= 9		//0-9分为重度，记为0，
replace cognition = 1 if cognition >= 10 & cognition <= 20		//10-20分为中度，记为1
replace cognition = 2 if cognition >= 21 & cognition <= 24		//21-24分为轻度，记为2
replace cognition = 3 if cognition >= 25 & cognition <= 30		//25-30分为正常，记为3

tab cognition
sum cognition



// 自变量：居住方式，
gen livingstatus = a51
recode livingstatus 9 = . //1家庭成员同住，2独居，3养老院



// 个体层次控制变量：性别，年龄，婚姻，教育，户口
gen gender = a1	//性别编码，0=女，1=男
recode gender 2 = 0 1 = 1

gen age = trueage
replace age = 0 if age < 80 & age >= 60		//中低龄
replace age = 1 if age >= 80 & age <=110	//高龄老人
replace age = . if age != 0 & age != 1

gen marrige = f41
recode marrige 1 2 = 1 3 4 5 = 0 8 9 = .	//已婚（含是否与配偶住一起）记为1，离婚丧偶未婚为0

gen education = f1
recode education 0 = 0 1/6 = 1 7/9 = 2 10/12 = 3 13/20 = 4	//0年未受过教育；1-6小学；7-9初中；8-12高中；13-20大学及以上
replace education = . if education < 0 | education > 4	//其他情况如超过20年记为.

gen kukou = a43
recode hukou 1 = 1 2 = 0 8 9 = .	//1城市，0农村

sum gender age marrige education hukou

cls
//健康行为控制变量：是否饮酒、是否抽烟、是否锻炼、是否有慢性病、ADL（日常生活能力限制）
gen smoking = d71
recode smoking 1=1 2=0 8 9=. // 1是吸烟，0不吸烟。下同

gen drinking = d81
recode drinking 1=1 2=0 9=.

gen exercise = d91
recode exercise 1=1 2=0 8 9=.

gen isdisease = g14a1	
replace isdisease = 0 if isdisease == .		//无病记为0
replace isdisease = 1 if isdisease != 0 & isdisease != 88 & isdisease != 99	//有病记为1 ！=是不等于的意思
recode isdisease 88 99 = .	//丢失和不知道记为.

gen activitylimit = e0
recode activitylimit 1 2 = 1 3 = 0 8 9 = . //日常活动受到限制，受到限制记为1，未受限记为0，其余情况记为.

sum smoking drinking exercise isdisease activitylimit

cls
// 社会经济控制变量:家庭年收入
gen incoming = f35
recode incoming 88888 99999 = .
// replace incoming = r(p1) if incoming < r(p1)
replace incoming = r(p99) if incoming > r(p99)	//右侧截尾处理
gen log_incoming = log(incoming + 1) //加1后取自然对数，使得取对数之后的结果大于等于0，因为In0=0没有任何意义，In1=0
sum log_incoming

