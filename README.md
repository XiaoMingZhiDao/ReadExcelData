# ReadDataFromExcel
###Excel内读取数据到数据库

---
#### 环境说明
* 目前环境是mac book pro，Excel后缀 .xlsx 

### Excel 处理
* 假设有```abc.xlsl``` excel表格，内有三列数据分别是A B C ，行数不限制
*  增加一列（D列），选中D列（记住是整列，否则就要手动拖拽），在Excel上方公式栏fx内输入输入公式```（="insert into table(field1,field2,field3) values"&"("&A1&","&B1&","&C1&")"）```，ctrl+enter。建议有多少拖多少，整列公式数据多了会很慢！
*  这是整个D列都生成如下的SQL语句：``` insert into mytable (field1,field2,field3、field4) values ('A1中 的数据','B1','C1','D1');```
*  某几行的数据公司可能不需要，手动删除即可；
*  选中D列把D列数据复制到一个纯文本文件中，命名为 例如:```abc.txt```
*  把```abc.txt``` 放到数据库中运行即可，可通过命令行导入
  source f:\abc.txt
  
---
## 若```abc.txt``` 不知如何处理，那么可放在```Xcode```内先读取，截取，然后再插入数据库;详见ReadExcelDataDemon。


  
  
  
  
  
  
  
  
  
  
  



