## 构建历史处理
//删除小于64的构建历史
def maxNumber = 3000
 
jenkins.model.Jenkins.instance.getJobNames().findAll{ name -> Jenkins.instance.getItemByFullName(name).builds.findAll {
  it.number <= maxNumber
}.each {
  it.delete()
} }
