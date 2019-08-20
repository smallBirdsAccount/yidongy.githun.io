# 脚本前提条件
# 1、配置github/gitlab/gitee等ssh key
# 2、源码存放在master分支, 静态文件默认存放在gh-pages分支
# 3、commit命令只进行提交master操作, build命令会执行commit操作后发布静态文件到gh-pages分支(默认)

# 指定默认参数
codeBranch=master    	# 代码分支
pageBranch=gh-pages 	# 页面分支
commitCommand=commit    # 提交命令
buildCommand=build 		# 打包命令

################## 可用函数 ##################

# 检查git忽略配置文件是否存在
function addGitIgnore {
	if [ ! -f ".gitignore" ]; then
		for p in $@
		do
		   	echo $p >> .gitignore
		done
	fi
}

# 提交代码
function commitCode {
	git add .
	git commit -m "$0"
	git push
}

# 判断gh-page分支是否存在, 不存在进行创建
function checkBranch {
	br = $(git branch | grep "$pageBranch")
	if [ ! -n "$br" ]; then
	    echo "branch $pageBranch is not exist, create branch";
	    # 进行分支创建, 并提交远程仓库
	    git branch $pageBranch
	    git checkout $pageBranch
	    git push origin
	    addGitIgnore _book node_modules
	    commitCode "init branch $pageBranch, add .gitignore"
	fi
}
################## 可用函数 ##################

# 查看当前所在分支, 如果不在master分支则切换到master分支
current_branch=`git symbolic-ref --short -q HEAD`
if [ "$current_branch" == "$codeBranch" ]; then
	echo "current branch is $current_branch"
else
	git checkout "$codeBranch"
fi

# 添加忽略配置文件, 忽略掉打包后以及node依赖目录
addGitIgnore _book node_modules

# 获取用户输入指令, commit或者build
read -p "Enter command $commitCommand or $buildCommand, default $commitCommand, please: " command

# 判断输入的命令是否合法, 非法直接退出
if [ "$command" != "$commitCommand" -a "$command" != "$buildCommand" -a "$command" != "" ]; then
	echo "Error command : $command, please rerun the script"
	exit 0
fi 

# 不输入命令时默认为commit
if [ "$command" == "" ]; then 
	command="$commitCommand"
fi
echo "The choose command is : $command"
read -p "Enter git commit message, please: " message

# 提交代码
commitCode message

# 判断是否执行打包操作
if [ "$command" == "$buildCommand" ]; then
	# 检查page分支是否存在
	checkBranch
	# 打包文件
	gitbook build
	# 切换分支
	git checkout $branch
	# 提交静态文件
	mv ./_book/* ./
	rm -rf ./_book
	git add .
	git commit -m '$message'
	git push
	# 切回master分支
	git checkout master
if

