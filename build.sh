# 切换到master分支
git checkout master

# 检查git忽略配置文件是否存在
if [! -f ".gitignore" ]; then
	echo "_book" >> .gitignore
	echo "node_modules" >> .gitignore
else
	# 检查忽略配置文件是否已配置忽略打包信息

fi

# 提交代码, 接收用户输入commit信息
git add .
read -p "Enter git commit message, please: " message
git commit -m '$message'
git push

# 根据输入参数判断是否进行静态文件打包
branch = $(git branch | grep $1)
if [! -n "$branch"]; then
    
else
    if [ -n "$branch" ]; then
	    echo "git $branch is exits"
	else
	    echo "git $branch is not exist";
	    # 进行分支创建, 并提交远程仓库
	    git branch $branch
	    git checkout $branch
	    git push origin
	    echo "_book" >> .gitignore
		echo "node_modules" >> .gitignore
		git add .
		git commit -m 'add .gitignore'
		git push
	fi
	# 打包文件
	gitbook build
	# 切换分支
	git checkout $branch
	# 提交静态文件
	mv ./_book/* ./
	rm -rf ./_book
	git add .
	git commit -m 'test'
	git push
	# 切回master分支
	git checkout master
fi

