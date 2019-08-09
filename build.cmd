# 提交代码
git checkout master
git add .
git commit -m 'test'
git push

# 打包文件
gitbook build

# 切换分支
git checkout gh-pages

# 提交静态文件
mv ./_book/* ./
rm -rf ./_book
git add .
git commit -m 'test'
git push

# 切回master分支
git checkout master
