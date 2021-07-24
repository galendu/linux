## 钉钉

https://jenkinsci.github.io/dingtalk-plugin/guide/getting-started.html#%E6%B3%A8%E6%84%8F

## 构建历史处理
//删除小于64的构建历史  
 
def maxNumber = 3000
 
jenkins.model.Jenkins.instance.getJobNames().findAll{ name -> Jenkins.instance.getItemByFullName(name).builds.findAll {
  it.number <= maxNumber
}.each {
  it.delete()
} }
