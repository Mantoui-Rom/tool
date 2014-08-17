#!/bin/bash
github_username=namantou
github_password=密码


repodir=/home/mantou/android/mantoui
rildir=/home/mantou/android/ril

# Create REPO
#curl -u "$github_username:$github_password" -d "{\"name\":\"$g_repo\"}" https://api.github.com/orgs/$g_origin/repos

# DELETE REPO
#curl -X DELETE --user $github_username:$github_password https://api.github.com/repos/$g_origin/$g_repo

# Create FORK
#curl -X POST --user $github_username:$github_password -d "{\"organization\":\"mantoui\"}" https://api.github.com/repos/$g_origin/$g_repo/forks

# List REPO FORM ORGS
#curl -X GET --user $github_username:$github_password -d "{\"type\":\"all\"}" https://api.github.com/orgs/$g_origin/repos

# List Branches
#curl -X GET --user $github_username:$github_password https://api.github.com/repos/$g_origin/$g_repo/branches
#curl -X GET --user $github_username:$github_password https://api.github.com/repos/$github_username/m_home/branches

# Edit REPO
#curl -X PATCH --user $github_username:$github_password -d "{\"name\":\"k_system_extras\"}" https://api.github.com/repos/$g_origin/m_system_extras
#curl -X PATCH --user $github_username:$github_password -d "{\"name\":\"k_system_extras\"}" https://api.github.com/repos/$github_username/m_system_extras

	

function get_readyesvno() 
{
	readtime=$1	#倒计时时间
	timeover=$2	#时间到了之后的默认值
	readword=$3	#提示的内容
	yesvno=-1	#设置未输入时的默认值

	if [ $readtime != 0 ];then
		case $timeover in
		-1)
			timeover_word="否";;
		1)
			timeover_word="是";;
		esac
		printf "\n $readword \e[33m[$readtime s Choose $timeover_word ]  \e[36m[Y / N]:\033[0m"
		read -t $readtime -n 1 yesvno
	else
		printf "\n $readword \e[36mNum:\033[0m"
		read -n 1 yesvno
	fi

		case $yesvno in
		Y | y)
			yesvno=1;;
		N | n)
			yesvno=0;;	
		*)
			if [ "$timeover" != 0 ];then 
				yesvno=$timeover
			else
				yesvno=1
			fi ;;
		esac
	printf "\n"
}
function get_readnum() 
{
	readnum=$1	#数字位数
	readtime=$2	#倒计时时间
	timeover=$3	#时间到了之后的默认值
	readword=$4	#提示的内容
	yesvno=1	#设置辅助字段默认为否
	num=-1		#设置未输入时的默认值
	if [ $readtime != 0 ];then
		printf "\n $readword \e[33m[$readtime s Choose $timeover]  \e[36m $readnum Num:\033[0m"
	else
		printf "\n $readword \e[36mNum:\033[0m"
	fi

	if [ "$readtime" -gt "0" -a "$readnum" = "1" ];then
		read -t $readtime -n $readnum num
		case $num in
		[1-9])
			return $num;;
		N | n)
			yesvno=0;;
		*)
			if [ "$timeover" != 0 ];then 
				num=$timeover
			fi
			yesvno=1;;
		esac
	elif [ "$readnum" = "1" ];then
		read -n $readnum num
		case $num in
		[1-9])
			return $num;;
		N | n)
			yesvno=0;;
		*)
			yesvno=1;;
		esac
	elif [ "$readtime" -gt "0" -a "$readnum" = "2" ];then
		read -t $readtime -n $readnum num
		case $num in
		[0-9][0-9])
			return $num;;		
		NN | nn)
			yesvno=0;;
		*)
			if [ "$timeover" != 0 ];then 
				num=$timeover
			fi
			yesvno=1;;
		esac
	elif [ "$readnum" = "2" ];then
		read -n $readnum num
		case $num in
		[0-9][0-9])
			return $num;;
		NN | nn)
			yesvno=0;;
		*)
			yesvno=1;;
		esac
	elif [ "$readnum" = "0" ];then
		read -n $readnum num
		case $num in
		N | n)
			yesvno=0;;
		*)
			yesvno=1;;
		esac
	fi
	printf "\n"
}

function get_readtext() 
{
	readword=$1
	readtitle=$2
	yesvno=1
	printf "\n\n $readword \e[31m$readtitle:\033[0m"
	read readtext
	case $readtext in
	N | n)
		yesvno=0;;
	*)
		yesvno=0;;
	esac
	printf "\n"
}



function action_repository() 
{
	repo_get_run=$1

	cd $repodir/$repo_get_c_1
	if [ $? = "1" ];then
		cd $repodir/
		case $repo_get_c_6 in
		0)
			printf "\n $repo_get_c_1 下没有找到这个目录 $repo_get_c_2 repo_get_c_6=$repo_get_c_6\n"
			cd $repodir
			repo_get_run=sync;;
		1)
			git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_1 -b $repo_get_c_9
			cd $repodir/$repo_get_c_1
			repo_get_run=first_fix;;
		2)
			git clone git@github.com:$repo_get_c_3/$repo_get_c_4.git $repo_get_c_1 -b $repo_get_c_5;;
		3)
			printf "\n 没有找到这个目录，repo_get_c_6=3\n";;
		esac
	fi	
	if [ "$repo_get_c_2" != "/" ];then
		cd $repo_get_c_2
		if [ $? = "1" ];then
			cd $repodir/$repo_get_c_1
			case $repo_get_c_6 in
			0)
				printf "\n $repo_get_c_1下没有找到这个目录$repo_get_c_2 repo_get_c_6=$repo_get_c_6\n"
				cd $repodir
				repo_get_run=sync;;
			1)
				git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_2 -b $repo_get_c_9
				cd $repodir/$repo_get_c_1/$repo_get_c_2
				repo_get_run=first_fix;;
			2)
				git clone git@github.com:$repo_get_c_3/$repo_get_c_4.git $repo_get_c_2 -b $repo_get_c_5;;
			3)
				printf "\n 没有找到这个目录，repo_get_c_6=$repo_get_c_6 \n";;
			esac

		fi
	fi

	case $repo_get_run in
	sync)
		cd $repodir
		repo sync  
		while [ $? = 1 ]; do  
			sleep 10
			repo sync  
		done	
		printf "\n";;
	status)
		git status	
		printf "\n";;
	add)
		git add -A
		printf "\n";;
	commit)
		git add -A
		git commit -a
		printf "\n";;
	stash)
		git diff -b
		git stash	
		printf "\n";;
	stashapply)
		git stash apply	
		git diff -b
		printf "\n";;
	checkout5)
		git checkout $repo_get_c_5		
		printf "\n";;
	checkout9)
		case $repo_get_c_6 in
		1 | 2 | 3)
			git checkout $repo_get_c_9;;
		esac	
		printf "\n";;
	checkoutf)
		git checkout --f		
		printf "\n";;
	merge)
		if [ $repo_get_c_7 != $repo_get_c_8 ];then
			case $repo_get_c_6 in
			0 | 1)
				git checkout $repo_get_c_5
				git merge $repo_get_c_7/$repo_get_c_9
				printf "\n";;
			2)
				git fetch origin
				git checkout $repo_get_c_5
				git merge origin/$repo_get_c_9
				printf "\n";;
			3)
				git fetch $repo_get_c_7
				git checkout $repo_get_c_5
				git merge $repo_get_c_7/$repo_get_c_9
				printf "\n";;
			esac
		elif [ $repo_get_c_3 != $repo_get_c_4 ];then
			case $repo_get_c_6 in
			0)
				git checkout $repo_get_c_5
				# 版本更新将需要修改 需要寻找更灵活的方法
				git merge refs/tags/android-4.4.4_r1
				printf "\n";;
			esac
		else
			printf "空行"
		fi
		
		printf "\n";;
	fetch3)
		git fetch $repo_get_c_3		
		printf "\n";;
	fetch7)
		case $repo_get_c_6 in
		0)
			git fetch aosp;;
		2)
			git fetch origin;;
		1 | 3)
			git fetch $repo_get_c_7 ;;
		esac
		printf "\n";;
	push)
		git checkout $repo_get_c_5
		git push git@github.com:$repo_get_c_3/$repo_get_c_4.git $repo_get_c_5
		printf "\n";;
	forkin)
		if [ $repo_get_c_7 != $repo_get_c_8 ];then
			curl -X POST --user $github_username:$github_password -d "{\"organization\":\"$repo_get_c_3\"}" https://api.github.com/repos/$repo_get_c_7/$repo_get_c_8/forks
		fi
		printf "\n";;
	forkout)
		if [ $readtextt ];then
			curl -X POST --user $github_username:$github_password -d "{\"organization\":\"$readtext\"}" https://api.github.com/repos/$repo_get_c_3/$repo_get_c_4/forks
		else
			get_readtext "请输入接受此 $repo_get_c_4 的仓库名 输入一次即可	" "仓库名"
			readtextt=1
			curl -X POST --user $github_username:$github_password -d "{\"organization\":\"$readtext\"}" https://api.github.com/repos/$repo_get_c_3/$repo_get_c_4/forks
		fi
		printf "\n";;
	renamerepo)
		if [ $readtextt ];then
			curl -X PATCH --user $github_username:$github_password -d "{\"name\":\"$readtext$repo_get_c_4\"}" https://api.github.com/repos/$repo_get_c_3/$repo_get_c_4
		else
			get_readtext "请输入要在 $repo_get_c_4 前添加的字段 输入一次即可		" "请输入"
			curl -X PATCH --user $github_username:$github_password -d "{\"name\":\"$readtext$repo_get_c_4\"}" https://api.github.com/repos/$repo_get_c_3/$repo_get_c_4
		fi
		printf "\n";;
	first)
		if [ $repo_get_c_10 = 1 ];then
			curl -u "$github_username:$github_password" -d "{\"name\":\"$repo_get_c_4\"}" https://api.github.com/orgs/$repo_get_c_3/repos
			case $repo_get_c_6 in
			0 | 1)
				git checkout $repo_get_c_9
				git checkout -b $repo_get_c_5 
				git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
				git remote -v
				git checkout $repo_get_c_5
				git push $repo_get_c_3 $repo_get_c_5 ;;
			2)
				if [ "$repo_get_c_2" != "/" ];then
					mkdir -p $repodir/$repo_get_c_1
					cd $repodir/$repo_get_c_1
					git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_2 -b $repo_get_c_9
					cd $repo_get_c_2
					git checkout -b $repo_get_c_5
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
					git push $repo_get_c_3 $repo_get_c_5 
				else
					cd $repodir
					git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_1 -b $repo_get_c_9
					cd $repo_get_c_1
					git checkout -b $repo_get_c_5
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
					git push $repo_get_c_3 $repo_get_c_5 
				fi ;;
			3)
				if [ "$repo_get_c_2" != "/" ];then
					cd $repodir/$repo_get_c_1/$repo_get_c_2
					git remote add $repo_get_c_7 git@github.com:$repo_get_c_7/$repo_get_c_8.git
					git fetch $repo_get_c_7
					git checkout $repo_get_c_9		
					git checkout -b $repo_get_c_5
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
					git push $repo_get_c_3 $repo_get_c_5
				else
					cd $repodir
					git remote add $repo_get_c_7 git@github.com:$repo_get_c_7/$repo_get_c_8.git
					git fetch $repo_get_c_7
					git checkout $repo_get_c_9
					git checkout -b $repo_get_c_5
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
					git push $repo_get_c_3 $repo_get_c_5
				fi ;;
			esac
			
		fi
		printf "\n";;
	first_fix)
		if [ $repo_get_c_10 = 1 ];then
			#curl -u "$github_username:$github_password" -d "{\"name\":\"$repo_get_c_4\"}" https://api.github.com/orgs/$repo_get_c_3/repos
			case $repo_get_c_6 in
			0 | 1)
				git checkout -b $repo_get_c_5
				git remote rm $repo_get_c_3
				git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
				git remote -v
				git checkout $repo_get_c_5;;
			2)
				if [ "$repo_get_c_2" != "/" ];then
					mkdir -p $repodir/$repo_get_c_1
					cd $repodir/$repo_get_c_1
					git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_2 -b $repo_get_c_9
					cd $repo_get_c_2
					git checkout -b $repo_get_c_5
					git remote rm $repo_get_c_3
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
				else
					cd $repodir
					git clone git@github.com:$repo_get_c_7/$repo_get_c_8.git $repo_get_c_1 -b $repo_get_c_9
					cd $repo_get_c_1
					git checkout -b $repo_get_c_5
					git remote rm $repo_get_c_3
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
				fi ;;
			3)
				if [ "$repo_get_c_2" != "/" ];then
					cd $repodir/$repo_get_c_1/$repo_get_c_2
					git remote rm $repo_get_c_7
					git remote add $repo_get_c_7 git@github.com:$repo_get_c_7/$repo_get_c_8.git
					git fetch $repo_get_c_7
					git checkout $repo_get_c_9		
					git checkout -b $repo_get_c_5
					git remote rm $repo_get_c_3
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
				else
					cd $repodir
					git remote rm $repo_get_c_7
					git remote add $repo_get_c_7 git@github.com:$repo_get_c_7/$repo_get_c_8.git
					git fetch $repo_get_c_7
					git checkout $repo_get_c_9
					git checkout -b $repo_get_c_5
					git remote rm $repo_get_c_3
					git remote add $repo_get_c_3 git@github.com:$repo_get_c_3/$repo_get_c_4.git
					git remote -v
					git checkout $repo_get_c_5
				fi ;;
			esac
			
		fi
		printf "\n";;
	esac
}


function make_repository() 
{
	repo_get_txt=$1		#调取的文件
	repo_get_row=$2		#调取指定行或者列表 0 代表所有非空行
	repo_get_run=$3		#动作类型 
	repo_get_return=$4	#返回数据的类型

	cd $filepath

	if [ -f $repo_get_txt -a -s $repo_get_txt ];then
		# 调取指定行的操作
		#repo_get_row_s=`printf "%01d" $repo_get_row`
		repo_get_row0=$(( (repo_get_row-1)/10 ))
		if [ $repo_get_row0 = "0" ];then
			repo_get_row_s=`printf "%01d" $repo_get_row`
		else
			repo_get_row_s=$repo_get_row
		fi
		if [ "$repo_get_row" != 0 ];then			
			repo_get_c_1=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $1}'`
			repo_get_c_2=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $2}'`
			repo_get_c_3=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $3}'`
			repo_get_c_4=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $4}'`
			repo_get_c_5=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $5}'`
			repo_get_c_6=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $6}'`
			repo_get_c_7=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $7}'`
			repo_get_c_8=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $8}'`
			repo_get_c_9=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $9}'`
			repo_get_c_10=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $10}'`
			repo_get_c_11=`cat $repo_get_txt|awk 'NR=="'$repo_get_row_s'" {print $11}'`
	
			case $repo_get_return in
			0)
				printf "\n";;
			1)
				repo_get_row2=`printf "%02d" $repo_get_row`
				printf "\n"
				printf " \e[35m------------------------------------------------------------------------------------------------------------------------------------------------------------\033[0m\n"
				printf "%7s %10s/%-46s %14s   |   %12s/%-46s%-14s\n"  "[$repo_get_row2]" "$repo_get_c_3"      $repo_get_c_4           "$repo_get_c_5"	"$repo_get_c_7"      $repo_get_c_8           "$repo_get_c_9"
				printf " \e[32m  ^__^ \033[0m\33[42m = $repo_get_row2 = \033[0m\e[32m ——————— 动作： $repo_get_run ——————— 目录： \033[0m\33[42m $repo_get_c_1/$repo_get_c_2 \033[0m\e[32m ————————————————————————————————————————————————————\n\033[0m"
				printf "\n";;	
			esac
			if [ $repo_get_run != "1" ];then
				if [ $repo_get_c_10 = 1 ];then
					action_repository $repo_get_run
				fi
			fi
		# 全部列表操作
		else
			repo_get_row=$repo_file_rows		#保留总行数
			while (( $repo_get_row >= $repo_file_start_row )) 
			do	
				cd $filepath
				repo_get_c_1=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $1}'`
				repo_get_c_2=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $2}'`
				repo_get_c_3=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $3}'`
				repo_get_c_4=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $4}'`
				repo_get_c_5=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $5}'`
				repo_get_c_6=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $6}'`
				repo_get_c_7=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $7}'`
				repo_get_c_8=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $8}'`
				repo_get_c_9=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $9}'`
				repo_get_c_10=`cat $repo_file_txt|awk 'NR=="'$repo_get_row'" {print $10}'`
				#repo_c_11=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $11}'`

				#非空行
				if [ "$repo_get_c_1" != "$repo_get_c_3" ];then 
					case $repo_get_return in
					0)
						printf "\n";;
					1)
					repo_get_row2=`printf "%02d" $repo_get_row`
						printf " \e[35m------------------------------------------------------------------------------------------------------------------------------------------------------------\033[0m\n"
						printf "%7s %10s/%-46s %14s   |   %12s/%-46s%-14s\n"  "[$repo_get_row2]" "$repo_get_c_3"      $repo_get_c_4           "$repo_get_c_5"	"$repo_get_c_7"      $repo_get_c_8           "$repo_get_c_9"
						printf " \e[32m  ^__^ \033[0m\33[42m = $repo_get_row2 = \033[0m\e[32m ——————— 动作： $repo_get_run ——————— 目录： \033[0m\33[42m $repo_get_c_1/$repo_get_c_2 \033[0m\e[32m ————————————————————————————————————————————————————\n\033[0m"
						printf "\n";;
					2)
						if [ "X$r1" != "X" ];then
							printf " \e[35m路径:		    $orgdir/$r1\n"
						fi
						if [ "X$r2" != "X" ];then
							printf " 目录:	 	    $r2\n\n"
						fi
						if [ "X$r3" != "X" ];then
							printf " 本地仓库:          $r3\n"
						fi
						if [ "X$r4" != "X" ];then
							printf " 本地项目名:        $r4"
						fi
						printf " \e[32m^—^— \033[0m\33[42m = $repo_get_row = \033[0m\e[32m —————————————————————————————————————————————————————————————\033[0m\n\n"
						printf "\n";;
					esac
					if [ $repo_get_c_10 = 1 ];then
						action_repository $repo_get_run
					fi
				fi
				#全部行
				let repo_get_row--
			done
		fi	
	else
		printf " \e[31m警告：$repo_get_txt 文件不存在或者空文件\033[0m\n\n"
		exit
	fi
}

function get_repository() 
{
	repo_file_txt=$1			#文件名
	repo_file_start_row=$2			#有效内容开始行
	repo_file_return=$3			#定义返回信息  1 只返回统计数据  2 返回列表和统计数据

	repo_file_rows=`cat $repo_file_txt|awk 'BEGIN{t=0;} {t++;}  END{printf t;}'`	#统计文件行数
	repo_file_row=$repo_file_rows		#保留总行数
	repo_file_no_null_rows=0		#统计非空行
	repo_file_rows_fetch=0			#统计可同步行
	repo_file_rows_from_loc=0		#统计 c_6=0 代表来自本地项目，将不会同步，即使 c_10=1 也不会进行同步
	repo_file_rows_from_github=0		#统计 c_6=1 代表来自github项目，如果 c_10=1 需要在执行在 repo syns 后进行合并或者可以进行同步合并操作
	repo_file_rows_from_google=0		#统计 c_6=2 代表来自google项目，如果 c_10=1 需要在执行在 repo syns 后进行合并 
	repo_file_rows_from_other=0		#统计 c_6=3 代表来自其他github项目，如果 c_10=1 将直接进行remote add 操作后 同步合并


	while (( $repo_file_row >= $repo_file_start_row )) 
	do
		cd $filepath
		repo_c_1=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $1}'`
		repo_c_2=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $2}'`
		repo_c_3=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $3}'`
		repo_c_4=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $4}'`
		repo_c_5=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $5}'`
		repo_c_6=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $6}'`
		repo_c_7=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $7}'`
		repo_c_8=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $8}'`
		repo_c_9=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $9}'`
		repo_c_10=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $10}'`
		repo_c_11=`cat $repo_file_txt|awk 'NR=="'$repo_file_row'" {print $11}'`
	
		#非空行
		if [ "$repo_c_1" != "$repo_c_3" ];then 
			let repo_file_no_null_rows+=1

			#统计代码来源
			case $repo_c_6 in
			0)
				let repo_file_rows_from_loc++;;
			1)
				let repo_file_rows_from_github++;;
			2)
				let repo_file_rows_from_google++;;
			3)
				let repo_file_rows_from_other++;;
			esac
			#统计可同步行
			if [ "$repo_c_10" = 1 -a "$repo_c_6" != 0 ];then 
				let repo_file_rows_fetch++
			fi 

			if [ "$repo_file_return" = 2 ];then
				repo_file_row2=`printf "%02d" $repo_file_row`
				printf "%7s %10s/%-46s %14s   |   %12s/%-46s%-14s\n"  "[$repo_file_row2]" "$repo_c_3"      $repo_c_4           "$repo_c_5"	"$repo_c_7"      $repo_c_8           "$repo_c_9"
				printf " \e[35m------------------------------------------------------------------------------------------------------------------------------------------------------------\033[0m\n"
			fi

		fi

		#全部行
		let repo_file_row--
	done
		#返回结果 1 返回完整信息 
		case $repo_file_return in
		1 | 2)
			printf " \e[35m\n------------------------------------------------------------------------------------------------------------------------------------------------------------\033[0m\n"
			printf " 文件 [ \e[36m$repo_file_txt \033[0m] 共列出 [ \e[36m> $repo_file_rows < \033[0m] 行，[ \e[36m> $repo_file_no_null_rows < \033[0m] 个项目，可同步 [\e[32m > $repo_file_rows_fetch < \033[0m]   本地：[ \e[36m> $repo_file_rows_from_loc < \033[0m]  Github:[ \e[36m> $repo_file_rows_from_github < \033[0m]  Google:[ \e[36m> $repo_file_rows_from_google < \033[0m]  第三方:[ \e[36m> $repo_file_rows_from_other < \033[0m]\n"
			printf " \e[33m------------------------------------------------------------------------------------------------------------------------------------------------------------\033[0m\n";;
		esac
}


#============================================================================================================================================================

function action_devices() 
{
	device_make=$1
	case $device_make in
	1)
		case $device_c_8 in
		1)
			export BUILDTYPE_NIGHTLY=1
			export -n BUILDTYPE_RELEASE=0
			export -n BUILDTYPE_TEST=0 ;;
		2)
			export -n BUILDTYPE_NIGHTLY
			export BUILDTYPE_RELEASE=1
			export -n BUILDTYPE_TEST ;;
		3)
			export -n BUILDTYPE_NIGHTLY=0
			export -n BUILDTYPE_RELEASE=0
			export BUILDTYPE_TEST=1 ;;
		*)
			export BUILDTYPE_NIGHTLY=1
			export -n BUILDTYPE_RELEASE=0
			export -n BUILDTYPE_TEST=0 ;;
		esac

		get_readyesvno 30 1 "\n\n ======== 开始编译设备 $device_c_1 吗？				"
		if [ "$yesvno" -ge "1" ];then
			printf "\n"
			cd $repodir/hardware/ril
			if [ $device_c_3 = "omni" ];then
				git checkout kitkat
			elif [ $device_c_3 = "cm" ];then
				git checkout kitkat-cm
			fi
			rm -rf $repodir/out/target/product/$device_c_1/system/build.prop
			cd $repodir
			export USE_CCACHE=1
			export CCACHE_DIR=/home/mantou/.ccache
			source build/envsetup.sh
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 开始编译\033[0m						\e[36m》》》 请等待... 》》\033[0m\n\n"
			brunch $device_c_1
		else
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 \033[0m							\e[36m》》》 放弃 》》\033[0m\n\n"
		fi;;
	2)

		export BUILDTYPE_NIGHTLY=1
		export -n BUILDTYPE_RELEASE=0
		export -n BUILDTYPE_TEST=0

		get_readyesvno 30 1 "\n\n ======== 开始编译设备 $device_c_1 NIGHTLY版本吗？			"
		if [ "$yesvno" -ge "1" ];then
			printf "\n"
			cd $repodir/hardware/ril
			if [ $device_c_3 = "omni" ];then
				git checkout kitkat
			elif [ $device_c_3 = "cm" ];then
				git checkout kitkat-cm
			fi
			rm -rf $repodir/out/target/product/$device_c_1/system/build.prop
			cd $repodir
			export USE_CCACHE=1
			export CCACHE_DIR=/home/mantou/.ccache
			source build/envsetup.sh
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 开始编译\033[0m						\e[36m》》》 请等待... 》》\033[0m\n\n"
			brunch $device_c_1
		else
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 \033[0m							\e[36m》》》 放弃 》》\033[0m\n\n"
		fi;;	
	3)

		export -n BUILDTYPE_NIGHTLY=0
		export BUILDTYPE_RELEASE=1
		export -n BUILDTYPE_TEST=0

		get_readyesvno 30 1 "\n\n ======== 开始编译设备 $device_c_1 RELEASE版本吗？			"
		if [ "$yesvno" -ge "1" ];then
			printf "\n"
			cd $repodir/hardware/ril
			if [ $device_c_3 = "omni" ];then
				git checkout kitkat
			elif [ $device_c_3 = "cm" ];then
				git checkout kitkat-cm
			fi
			rm -rf $repodir/out/target/product/$device_c_1/system/build.prop
			cd $repodir
			export USE_CCACHE=1
			export CCACHE_DIR=/home/mantou/.ccache
			source build/envsetup.sh
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 开始编译\033[0m						\e[36m》》》 请等待... 》》\033[0m\n\n"
			brunch $device_c_1
		else
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 \033[0m							\e[36m》》》 放弃 》》\033[0m\n\n"
		fi;;
	4)

		export -n BUILDTYPE_NIGHTLY=0
		export -n BUILDTYPE_RELEASE=0
		export BUILDTYPE_TEST=1

		get_readyesvno 30 1 "\n\n ======== 开始编译设备 $device_c_1 TEST版本吗？			"
		if [ "$yesvno" -ge "1" ];then
			printf "\n"
			cd $repodir/hardware/ril
			if [ $device_c_3 = "omni" ];then
				git checkout kitkat
			elif [ $device_c_3 = "cm" ];then
				git checkout kitkat-cm
			fi
			rm -rf $repodir/out/target/product/$device_c_1/system/build.prop
			cd $repodir
			export USE_CCACHE=1
			export CCACHE_DIR=/home/mantou/.ccache
			source build/envsetup.sh
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 开始编译\033[0m						\e[36m》》》 请等待... 》》\033[0m\n\n"
			brunch $device_c_1
		else
			printf "\n\n\e[33m ======== 第 $device_select_rows 行 $device_c_1 \033[0m							\e[36m》》》 放弃 》》\033[0m\n\n"
		fi;;
	5)
				get_readyesvno 15 1 "确认开始配置设备 \33[42m  $device_c_1  \033[0m  吗?				"
				if [ "$yesvno" -eq "1" ];then
					get_readnum 1 15 1 "请选择编译版本 1=NIGHTLY 2=RELEASE 3=TEST *=NIGHTLY		"
					if [ "$yesvno" -eq "1" ];then
						case $num in
						1)
							export BUILDTYPE_NIGHTLY=1
							export -n BUILDTYPE_RELEASE=0
							export -n BUILDTYPE_TEST=0 ;;
						2)
							export -n BUILDTYPE_NIGHTLY
							export BUILDTYPE_RELEASE=1
							export -n BUILDTYPE_TEST ;;
						3)
							export -n BUILDTYPE_NIGHTLY=0
							export -n BUILDTYPE_RELEASE=0
							export BUILDTYPE_TEST=1 ;;
						*)
							export BUILDTYPE_NIGHTLY=1
							export -n BUILDTYPE_RELEASE=0
							export -n BUILDTYPE_TEST=0 ;;
						esac
					elif [ "$yesvno" -eq "2" ];then
						case $device_c_8 in
						1)
							export BUILDTYPE_NIGHTLY=1
							export -n BUILDTYPE_RELEASE=0
							export -n BUILDTYPE_TEST=0 ;;
						2)
							export -n BUILDTYPE_NIGHTLY
							export BUILDTYPE_RELEASE=1
							export -n BUILDTYPE_TEST ;;
						3)
							export -n BUILDTYPE_NIGHTLY=0
							export -n BUILDTYPE_RELEASE=0
							export BUILDTYPE_TEST=1 ;;
						*)
							export BUILDTYPE_NIGHTLY=1
							export -n BUILDTYPE_RELEASE=0
							export -n BUILDTYPE_TEST=0 ;;
						esac
					fi
					get_readyesvno 15 1 "是否切换基带 \33[42m  $device_c_1  \033[0m  吗?					"
					if [ "$yesvno" -eq "1" ];then
						cd $repodir/hardware/ril
						if [ $device_c_3 = "omni" ];then
							git checkout kitkat
						elif [ $device_c_3 = "cm" ];then
							git checkout kitkat-cm
						fi
					else
						printf "\n"
						cd $repodir/hardware/ril
						git status
						printf "\n ======== 	 							\e[36m》》》保留目前的 ril 》》  \n"
					fi
					get_readyesvno 10 1 " 确认开始编译设备 \33[42m  $device_c_1  \033[0m  吗?				"
					if [ "$yesvno" -eq "1" ];then
						printf "\n\n"
						rm -rf $repodir/out/target/product/$device_c_1/system/build.prop
						cd $repodir
						export USE_CCACHE=1
						export CCACHE_DIR=/home/mantou/.ccache
						source build/envsetup.sh
						printf "\n\n\e[33m ======== 第 $vardd 行 $device_c_1 开始编译\033[0m					\e[36m》》》 请等待... 》》\033[0m\n\n"
						brunch $device_c_1
					else
						printf "\n\n\e[33m ======== 第 $vardd 行 $device_c_1 设备被 ( 手动 ) 取消\033[0m					\e[36m》》》 放弃 》》\033[0m\n\n"
					fi

				fi;;
	*)
		printf "\n\n ======== 跳过 \n\n";;
	esac
		
	


}

function make_devices() 
{
	device_file_txt=$1				#文件名
	device_file_start_row=$2			#有效内容开始行
	device_select_rows=$3  				#是否指定行
	device_file_return=$4				#定义返回信息  1 只返回统计数据  2 返回列表和统计数据
	device_file_skip_null=$5			#是否跳过空行
	device_make_action=$6

		printf "\n\n1== $num\n\n"

	if [ $device_select_rows -ge $device_file_start_row ];then
		device_select_rowsn=`printf "%03d" $device_select_rows` #补全三位数 003
		if [[ "${device_can_make_row_arr3[@]/$device_select_rowsn/}" = "${device_can_make_row_arr3[@]}" ]];then
			printf "\n\e[31m 警告：编号（行）$device_select_rows的设备配置有误请检查\033[0m\n\n"
			return
		else
			get_devices $device_file_txt $device_file_start_row $device_select_rows $device_file_return $device_file_skip_null
			action_devices $device_make_action
		fi
	else
		for device_select_rows in ${device_can_make_row_arr[*]}
		do
			get_devices $device_file_txt $device_file_start_row $device_select_rows $device_file_return $device_file_skip_null
			action_devices $device_make_action
		done
	fi
}


function get_devices() 
{
	device_file_txt=$1				#文件名
	device_file_start_row=$2			#有效内容开始行
	device_select_rows=$3  				#是否指定行
	device_file_return=$4				#定义返回信息  1 只返回统计数据  2 返回列表和统计数据
	device_file_skip_null=$5			#是否跳过空行

	device_file_rows=`cat $device_file_txt|awk 'BEGIN{t=0;} {t++;}  END{printf t;}'`	#统计文件行数
	device_file_row=$device_file_rows		#保留总行数
	device_file_no_null_rows=0			#统计非空行
	device_file_rows_make=0				#统计可同步行

	printf "\n\n"
	if [ -f $device_file_txt -a -s $device_file_txt ];then
		if [ "$device_select_rows" -ge  "$device_file_start_row" ];then
			printf " \e[32m您当前选择读取的文件是：$device_file_txt , 正在查找[ \e[36m> $device_select_rows < \033[0m\e[32m]设备信息\033[0m\n"
				printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
		else
			printf " \e[32m您当前选择读取的文件是：$device_file_txt , 已找到以下是设备配置信息, 请确认！\033[0m\n"
				printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
		fi	
	else
		printf " \e[31m警告：$device_files 文件不存在或者空文件\033[0m\n\n"
		exit
	fi
	if [ $device_select_rows -ge $device_file_start_row ];then
		device_c_1=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $1}'`
		device_c_2=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $2}'`
		device_c_3=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $3}'`
		device_c_4=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $4}'`
		device_c_5=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $5}'`
		device_c_6=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $6}'`
		device_c_7=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $7}'`
		device_c_8=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $8}'`
		device_c_9=`cat $device_file_txt|awk 'NR=="'$device_select_rows'" {print $9}'`

		if [ $device_c_1 != $device_c_2 ];then
				printf "%8s %19s %11s %19s %11s %11s %11s %11s %11s %11s\n"  "编号" "设备  " "缓存" "基带" "内置" "推广" "备选" "备选" "版本" "编译"
				printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
				printf "%5s %16s %9s %17s %9s %9s %9s %9s %9s %9s\n"  "[$device_select_rows]" "$device_c_1" "$device_c_2" "$device_c_3" "$device_c_4" "$device_c_5" "$device_c_6" "$device_c_7" "$device_c_8" "$device_c_9"
				printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
		else
			printf "\n\e[31m 警告：编号（行）$device_select_rows 是空行，请确认\033[0m\n\n"
		fi
	elif [ $device_file_return -ge "1" ];then
		if [ $device_file_return -eq "2" ];then
			printf "%8s %19s %11s %19s %11s %11s %11s %11s %11s %11s\n"  "编号" "设备  " "缓存" "基带" "内置" "推广" "备选" "备选" "版本" "编译"
			printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
		fi
		while (( $device_file_row >= $device_file_start_row )) 
		do
			device_c_1=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $1}'`
			device_c_2=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $2}'`
			device_c_3=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $3}'`
			device_c_4=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $4}'`
			device_c_5=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $5}'`
			device_c_6=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $6}'`
			device_c_7=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $7}'`
			device_c_8=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $8}'`
			device_c_9=`cat $device_file_txt|awk 'NR=="'$device_file_row'" {print $9}'`

			if [ $device_c_1 ];then
				let device_file_no_null_rows++
				if [ $device_c_9 = "1" ];then
					let device_file_rows_make++
					#可编译设备写入数组
					device_can_make_row=`printf "%03d" $device_file_row`
					device_can_make_row_arr3[$device_file_row]=$device_can_make_row
					device_can_make_row_arr[$device_file_row]=$device_file_row
				fi 
			fi
			if [ $device_file_return = "2" ];then
				if [ -z $device_c_3 ];then
					if [ $device_file_skip_null != "1" ];then
						printf "%5s %16s %9s %17s %9s %9s %9s %9s %9s %9s\n"  "[$device_file_row]" "-" "-" "-" "-" "-" "-" "-" "-" "-"
						printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
					fi
				else
					printf "%5s %16s %9s %17s %9s %9s %9s %9s %9s %9s\n"  "[$device_file_row]" "$device_c_1" "$device_c_2" "$device_c_3" "$device_c_4" "$device_c_5" "$device_c_6" "$device_c_7" "$device_c_8" "$device_c_9"
					printf " \e[35m-------------------------------------------------------------------------------------------------------------------\033[0m\n"
				fi
			fi

		let device_file_row--
		done
		if [ $device_file_return = "1" -o $device_file_return = "2" ];then
			printf " \e[35m———————————————————————————————————————————————————————————————————————————————————————————————————————————————————\033[0m\n"
			printf " 文件共列出 [ \e[36m> $device_file_rows < \033[0m] 行, [ \e[36m> $device_file_no_null_rows < \033[0m] 个设备, 默认可编译 [\e[32m > $device_file_rows_make < \033[0m] 个设备\n"
			printf " \e[33m———————————————————————————————————————————————————————————————————————————————————————————————————————————————————\033[0m\n"
		fi
	fi
}






printf " \e[31m-----------------------------------------------------------------------------------------\033[0m\n"
printf " \e[39m-----------------------------------------------------------------------------------------\033[0m\n"
printf " \e[32m-----------------------------------------------------------------------------------------\033[0m\n"
printf " \e[33m>>>>>>>>>>>>>>>>>>>>>>>>>>        源码编译管理工具箱        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<\033[0m\n"
printf " \e[34m-----------------------------------------------------------------------------------------\033[0m\n"
printf " \e[35m------------------------------------------------------------ Mantoui 2014-08-04 ---------\033[0m\n"
printf " \e[36m-----------------------------------------------------------------------------------------\033[0m\n\n"


#项目
repo_files=repo_lists.txt 		#读取的文件名
repo_file_start_row=2
#设备
device_files=devices.txt 		#读取的文件名
device_file_start_row=2





printf " \e[33m*****************************************************************************************\033[0m\n\n"
printf " \e[33m  ----->  [1] = 全 自 动 同 步 编 译		\e[35m--同步 > 合并 > Push > 编译\033[0m\n\n" 
printf " \e[33m  ----->  [2] = 全 自 动 合 并 代 码		\e[35m--同步 > 合并 > Push	\033[0m\n\n" 
printf " \e[33m  ----->  [3] = 代 码 批 量 操 作		\e[35m--统计/分支/保存/同步/合并....\033[0m\n\n\n"
printf " \e[33m  ----->  [4] = 自 定 义 项 目 操 作		\e[35m--选择指定行统计/分支/保存/同步/合并....\033[0m\n\n\n"

printf " \e[33m  ----->  [8] = 全 自 动 编 译 设 备		\e[35m--按照文件配置批量编译设备\033[0m\n\n"
printf " \e[33m  ----->  [9] = 自 定 义 编 译 设 备		\e[35m--单独选择设备进行编译设置\033[0m\n\n"
printf " \e[33m*****************************************************************************************\033[0m\n"


#get_readnum 位数 时间 默认值 内容
get_readnum 1 5 1 "请输入选择的模式前的编号					"
if [ "$yesvno" -eq "1" -a "$num" = "1" ];then
	printf "\n\n"
	#get_readyesvno 时间 默认值 内容
	get_readyesvno 10 1 "警告：本操作可能会出现合并失败导致的的中断			"
	if [ "$yesvno" -eq "1" ];then
		get_repository $repo_files 2 2
		get_readyesvno 10 1 "开始执行 保存本地修改 stash					" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 add 1
				make_repository $repo_files 0 stash 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi
		get_readyesvno 10 1 "开始执行 repo sync						" 
			if [ "$yesvno" -eq "1" ];then
				action_repository sync
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi
		get_readyesvno 10 1 "开始执行 Merge 合并						" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 merge 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi

		get_readyesvno 10 -1 "合并完成是否 Push ？  建议不进行（默认跳过 Push）		"
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 push 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi

		get_readyesvno 10 1 "是否还原之前保存的修改？					" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 stashapply 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi

		printf "\n\n ======== 进入编译模式， 请稍后...... "
		cd $filepath
		get_devices $device_files $device_file_start_row 1 2 1
		get_readyesvno 10 1 "确定按照以上列表配置开始编译吗？				"
			if [ "$yesvno" -eq "1" ];then
				read -t 5 -p "\n是否执行 make clean ？ 5s 自动跳过		[Y/y] / [*]:" makec
				case $makec in
				Y | y)
					cd $repodir
					make clean 
					printf"\n make clean 完成";;
				*)
					printf"\n 你放心我没有执行 make clean  -_- \n\n";;
				esac
				make_devices $device_files $device_file_start_row 1 2 1 1
			fi
		
	fi

elif [ "$yesvno" -eq "1" -a "$num" = "2" ];then
	printf "\n\n"
	#get_readyesvno 时间 默认值 内容
	get_readyesvno 10 1 "警告：本操作可能会出现合并失败导致的的中断			"
	if [ "$yesvno" -eq "1" ];then
		get_repository $repo_files 2 2
		get_readyesvno 10 1 "开始执行 保存本地修改 stash				" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 add 1
				make_repository $repo_files 0 stash 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi
		get_readyesvno 10 1 "开始执行 repo sync					" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 checkout9 1
				action_repository sync
				make_repository $repo_files 0 checkout5 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi
		get_readyesvno 10 1 "开始执行 Merge 合并					" 
			if [ "$yesvno" -eq "1" ];then
				
				make_repository $repo_files 0 merge 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi

		get_readyesvno 10 1 "合并完成是否 Push ？  建议不进行（默认跳过 Push）	"
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 push 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi

		get_readyesvno 10 1 "是否还原之前保存的修改？					" 
			if [ "$yesvno" -eq "1" ];then
				make_repository $repo_files 0 stashapply 1
			else
				printf "\n\n\e[33m ========  \033[0m								\e[36m》》》 放弃 》》\033[0m\n\n"
			fi
		
	fi

elif [ "$yesvno" -eq "1" -a "$num" = "3" ];then
	printf "\n\n"
	printf " \e[33m*****************************************************************************************\033[0m\n\n"
	printf " \e[33m  ----->  [01] = 同步 基础代码 repo sync	\e[35m--\033[0m\n\n" 
	printf " \e[33m  ----->  [02] = 批量 git status 		\e[35m--\033[0m\n\n" 
	printf " \e[33m  ----->  [03] = 批量 git add -A		\e[35m--\033[0m\n\n" 
	printf " \e[33m  ----->  [04] = 批量 git commit -a		\e[35m--提交所有没有提交的代码\033[0m\n\n" 
	printf " \e[33m  ----->  [05] = 批量 git stash		\e[35m--保存所有没有提交的代码\033[0m\n\n" 
	printf " \e[33m  ----->  [06] = 批量 git stash apply		\e[35m--恢复所有没有提交的代码\033[0m\n\n" 
	printf " \e[33m  ----->  [07] = 批量 git check --f		\e[35m--清除所有未提交修改 Remote\033[0m\n\n" 
	printf " \e[33m  ----->  [08] = 批量 git merge c_5		\e[35m--批量合并到第五列\033[0m\n\n" 
	printf " \e[33m  ----->  [09] = 批量 git fetch c_3		\e[35m--批量同步\033[0m\n\n" 
	printf " \e[33m  ----->  [10] = 批量 git fetch c_7		\e[35m--批量同步\033[0m\n\n" 
	printf " \e[33m  ----->  [11] = 批量 git push			\e[35m--批量推送本地为同步的提交\033[0m\n\n" 
	printf " \e[33m  ----->  [12] = 批量 Fork C_7/C_8 到 C_3	\e[35m--批量fork第七列仓库的第八列的项目到第三列的仓库\033[0m\n\n" 
	printf " \e[33m  ----->  [13] = 批量 Fork C_3/C_4 到 C_7	\e[35m--批量fork第三列仓库的第四列的项目到第七列的仓库\033[0m\n\n" 
	printf " \e[33m  ----->  [14] = 批量 renamerepo		\e[35m--批量修改第三列仓库的第四列的项目前加一个前缀\033[0m\n\n" 
	printf " \e[33m----------------------------------------------------------------------------------------\033[0m\n\n"
	printf " \e[33m  ----->  [77] = 批量 add commit push C+3		\e[35m--\033[0m\n\n" 
	printf " \e[33m  ----->  [88] = 批量把基础代码 First		\e[35m--将根据文件批量建立分支和项目并push 到你的仓库\033[0m\n\n" 
	printf " \e[33m  ----->  [99] = 批量修复 First FIX		\e[35m--这里将只进行本地的分支建立以及Remote\033[0m\n\n"
	printf " \e[33m*****************************************************************************************\033[0m\n\n"
	get_readnum 2 30 01 "请输入选择的模式前的编号					"
	if [ "$yesvno" -eq "1" ];then
		printf "\n"
		get_repository $repo_files $repo_file_start_row 0
	fi	
	if [ "$yesvno" -eq "1" -a "$num" = "01" ];then
		make_repository $repo_files 0 sync 1
	elif [ "$yesvno" -eq "1" -a "$num" = "02" ];then
		make_repository $repo_files 0 status 1
	elif [ "$yesvno" -eq "1" -a "$num" = "03" ];then
		make_repository $repo_files 0 add 1
	elif [ "$yesvno" -eq "1" -a "$num" = "04" ];then
		make_repository $repo_files 0 commit 1
	elif [ "$yesvno" -eq "1" -a "$num" = "05" ];then
		make_repository $repo_files 0 stash 1
	elif [ "$yesvno" -eq "1" -a "$num" = "06" ];then
		make_repository $repo_files 0 stashapply 1
	elif [ "$yesvno" -eq "1" -a "$num" = "07" ];then
		make_repository $repo_files 0 checkoutf 1
	elif [ "$yesvno" -eq "1" -a "$num" = "08" ];then
		make_repository $repo_files 0 merge 1
	elif [ "$yesvno" -eq "1" -a "$num" = "09" ];then
		make_repository $repo_files 0 fetch3 1
	elif [ "$yesvno" -eq "1" -a "$num" = "10" ];then
		make_repository $repo_files 0 fetch7 1
	elif [ "$yesvno" -eq "1" -a "$num" = "11" ];then
		make_repository $repo_files 0 push 1
	elif [ "$yesvno" -eq "1" -a "$num" = "12" ];then
		make_repository $repo_files 0 forkin 1
	elif [ "$yesvno" -eq "1" -a "$num" = "13" ];then
		make_repository $repo_files 0 forkout 1
	elif [ "$yesvno" -eq "1" -a "$num" = "14" ];then
		make_repository $repo_files 0 renamerepo 1

	elif [ "$yesvno" -eq "1" -a "$num" = "77" ];then
		make_repository $repo_files $repo_num checkout5 1
		make_repository $repo_files $repo_num commit 1
		make_repository $repo_files $repo_num push 1
	elif [ "$yesvno" -eq "1" -a "$num" = "88" ];then
		make_repository $repo_files 0 first 1
	elif [ "$yesvno" -eq "1" -a "$num" = "99" ];then
		make_repository $repo_files 0 first_fix 1
	fi
elif [ "$yesvno" -eq "1" -a "$num" = "4" ];then
	if [ "$yesvno" -eq "1" ];then
		printf "\n\n"
		get_repository $repo_files $repo_file_start_row 2
	fi
	get_readnum 2 180 01 "请输入选择的你要操作的项目前的编号（行号）				"
	repo_num=$num
	if [ "$yesvno" -eq "1" ];then
		make_repository $repo_files $repo_num 1 1
		printf "\n\n"
		printf " \e[33m*****************************************************************************************\033[0m\n"
		printf " \e[33m  ----->  [01] = git status 			\e[35m--\033[0m\n" 
		printf " \e[33m  ----->  [02] = git add -A			\e[35m--\033[0m\n" 
		printf " \e[33m  ----->  [03] = git commit -a			\e[35m--提交所有没有提交的代码\033[0m\n" 
		printf " \e[33m  ----->  [04] = git stash			\e[35m--保存所有没有提交的代码\033[0m\n" 
		printf " \e[33m  ----->  [05] = git stash apply		\e[35m--恢复所有没有提交的代码\033[0m\n" 
		printf " \e[33m  ----->  [06] = git check --f			\e[35m--清除所有未提交修改 Remote\033[0m\n" 
		printf " \e[33m  ----->  [07] = git merge c_5			\e[35m--批量合并到第五列\033[0m\n" 
		printf " \e[33m  ----->  [08] = git fetch c_3			\e[35m--批量同步\033[0m\n" 
		printf " \e[33m  ----->  [09] = git fetch c_7			\e[35m--批量同步\033[0m\n" 
		printf " \e[33m  ----->  [10] = git push			\e[35m--批量推送本地为同步的提交\033[0m\n" 
		printf " \e[33m  ----->  [11] = Fork C_7/C_8 到 C_3		\e[35m--批量fork第七列仓库的第八列的项目到第三列的仓库\033[0m\n" 
		printf " \e[33m  ----->  [12] = Fork C_3/C_4 到 C_7		\e[35m--批量fork第三列仓库的第四列的项目到第七列的仓库\033[0m\n" 
		printf " \e[33m  ----->  [13] = renamerepo			\e[35m--批量修改第三列仓库的第四列的项目前加一个前缀\033[0m\n" 
		printf " \e[33m----------------------------------------------------------------------------------------\033[0m\n"
		printf " \e[33m  ----->  [77] = add commit push C+3		\e[35m--\033[0m\n" 
		printf " \e[33m  ----->  [88] = 把基础代码 First		\e[35m--将根据文件批量建立分支和项目并push 到你的仓库\033[0m\n" 
		printf " \e[33m  ----->  [99] = 修复 First FIX		\e[35m--这里将只进行本地的分支建立以及Remote\033[0m\n"
		printf " \e[33m*****************************************************************************************\033[0m\n\n"
		get_readnum 2 30 0 "请输入选择的模式前的编号					"
	
		if [ "$yesvno" -eq "1" -a "$num" = "01" ];then
			make_repository $repo_files $repo_num status 1
		elif [ "$yesvno" -eq "1" -a "$num" = "02" ];then
			make_repository $repo_files $repo_num add 1
		elif [ "$yesvno" -eq "1" -a "$num" = "03" ];then
			make_repository $repo_files $repo_num commit 1
		elif [ "$yesvno" -eq "1" -a "$num" = "04" ];then
			make_repository $repo_files $repo_num stash 1
		elif [ "$yesvno" -eq "1" -a "$num" = "05" ];then
			make_repository $repo_files $repo_num stashapply 1
		elif [ "$yesvno" -eq "1" -a "$num" = "06" ];then
			make_repository $repo_files $repo_num checkoutf 1
		elif [ "$yesvno" -eq "1" -a "$num" = "07" ];then
			make_repository $repo_files $repo_num merge 1
		elif [ "$yesvno" -eq "1" -a "$num" = "08" ];then
			make_repository $repo_files $repo_num fetch3 1
		elif [ "$yesvno" -eq "1" -a "$num" = "09" ];then
			make_repository $repo_files $repo_num fetch7 1
		elif [ "$yesvno" -eq "1" -a "$num" = "10" ];then
			make_repository $repo_files $repo_num push 1
		elif [ "$yesvno" -eq "1" -a "$num" = "11" ];then
			make_repository $repo_files $repo_num forkin 1
		elif [ "$yesvno" -eq "1" -a "$num" = "12" ];then
			make_repository $repo_files $repo_num forkout 1
		elif [ "$yesvno" -eq "1" -a "$num" = "13" ];then
			make_repository $repo_files $repo_num renamerepo 1

		elif [ "$yesvno" -eq "1" -a "$num" = "77" ];then
			make_repository $repo_files $repo_num checkout5 1
			make_repository $repo_files $repo_num commit 1
			make_repository $repo_files $repo_num push 1
		elif [ "$yesvno" -eq "1" -a "$num" = "88" ];then
			make_repository $repo_files $repo_num first 1
		elif [ "$yesvno" -eq "1" -a "$num" = "99" ];then
			make_repository $repo_files $repo_num first_fix 1
		fi
	fi
elif [ "$yesvno" -eq "1" -a "$num" = "8" ];then
	printf "\n\n"
	get_devices $device_files $device_file_start_row 1 2 1
	get_readyesvno 10 -1 "确定按照以上列表配置开始编译吗？				"
		if [ "$yesvno" -eq "1" ];then		
			make_devices $device_files $device_file_start_row 1 2 1 1
		fi
elif [ "$yesvno" -eq "1" -a "$num" = "9" ];then
	printf "\n\n"

	printf " \e[33m*****************************************************************************************\033[0m\n\n"
	printf " \e[33m  ----->  [1] = 自动编译 Night 版本		（可编译设备）\033[0m\n\n"
	printf " \e[33m  ----->  [2] = 自动编译 Release 版本		（可编译设备）\033[0m\n\n"
	printf " \e[33m  ----->  [3] = 自动编译 Test 版本		（全部）\033[0m\n\n"
	printf " \e[33m  ----->  [4] = 自定义编译选项\033[0m\n\n"
	printf " \e[33m*****************************************************************************************\033[0m\n\n"
	get_readnum 1 30 1 "请输入选择的模式前的编号					"
	if [ "$yesvno" -eq "1" -a "$num" = "1" ];then
		get_devices $device_files $device_file_start_row 1 2 1
		get_readyesvno 10 1 "确定开始编译列表中的设备的 Night 版本吗？				"
			if [ "$yesvno" -eq "1" ];then		
				make_devices $device_files $device_file_start_row 1 2 1 2
			fi
	elif [ "$yesvno" -eq "1" -a "$num" = "2" ];then
		get_devices $device_files $device_file_start_row 1 2 1
		get_readyesvno 10 1 "确定开始编译列表中的设备的 Night 版本吗？				"
			if [ "$yesvno" -eq "1" ];then		
				make_devices $device_files $device_file_start_row 1 2 1 3
			fi
	elif [ "$yesvno" -eq "1" -a "$num" = "3" ];then
		get_devices $device_files $device_file_start_row 1 2 1
		get_readyesvno 10 1 "确定开始编译列表中的设备的 Night 版本吗？				"
			if [ "$yesvno" -eq "1" ];then		
				make_devices $device_files $device_file_start_row 1 2 1 4
			fi
	elif [ "$yesvno" -eq "1" -a "$num" = "4" ];then
		get_devices $device_files $device_file_start_row 1 2 1
		get_readnum 1 30 1 "请输入选择的模式前的编号				"
		if [ "$yesvno" -eq "1" ];then
			make_devices $device_files $device_file_start_row $num 2 1 5
		fi
	fi
fi

