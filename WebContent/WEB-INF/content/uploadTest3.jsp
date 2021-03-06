<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>多文件上传，显示进度条实例</title>
<style type="text/css">
<!--
body, td, th {
    font-size: 9pt;
}
-->
</style>
<!--参考：http://api.jqueryui.com/progressbar/-->
<link rel="stylesheet" href="css/base/jquery.ui.all.css">
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery.ui.core.js"></script>
<script src="js/jquery.ui.widget.js"></script>
<script src="js/jquery.ui.progressbar.js"></script>

<script type="text/javascript">
    // 下面这三个函数是生成与刷新进度条、进度详细信息的
    // 初始化进度条
    $(function() {
        $("#progressbar").progressbar({
            value: 0
        });
    });
    
    // 调用查询进度信息接口
    function refreshProcessBar(){
        $.get("getState.action?timestamp=" + new Date().getTime(), function(data){
            refreshProcessBarCallBack(data);
        }, 'xml');
    }
    
    // 查询进度信息接口回调函数
    function refreshProcessBarCallBack(returnXMLParam){
        var returnXML = returnXMLParam;
        var percent = $(returnXML).find('percent').text()
        var showText = "进度是：" + percent + "%";
        showText = showText + "\n当前上传文件大小为：" + $(returnXML).find ('uploadByte').text();
        showText = showText + "\n上传文件总大小为：" + $(returnXML).find ('fileSizeByte').text();
        showText = showText + "\n当前上传文件为第：" + $(returnXML).find ('fileIndex').text() + "个";
        showText = showText + "\n开始上传时间：" + $(returnXML).find ('startTime').text();
        
        // 刷新进度详细信息
        $('#progressDetail').empty();
        $('#progressDetail').text(showText);
        
        // 刷新进度条
        $("#progressbar").progressbar("option", "value", parseInt(percent));
        
        setTimeout("refreshProcessBar()", 1000);
    }
    
    // 下面这三个函数是控制添加、删除、修改附件的（允许增加、删除附件，只允许指定后缀的文件被选择等）
    var a = 0;
    function file_change(){
        //当文本域中的值改变时触发此方法
        var postfix = this.value.substring(this.value.lastIndexOf(".") + 1).toUpperCase();
        //判断扩展是否合法
        if (postfix == "JPG" || postfix == "GIF" || postfix == "PNG" || postfix == "MP3" ||
            postfix == "RAR" ||
            postfix == "ZIP" ||
            postfix == "TXT" ||
            postfix == "HTML" ||
            postfix == "PDF") {
        }
        else {
            //如果不合法就删除相应的File表单及br标签
            alert("您上传的文件类型不被支持，本系统只支持JPG,GIF,PNG,BMP,RAR,ZIP,TXT文件！");
            var testtest = $(this).attr('id');
            testtest = '#' + testtest;
            var sub_file = $(testtest);
            
            var next_a_ele = sub_file.next();//取得a标记
            var br1_ele = $(next_a_ele).next();//取得回车
            var br2_ele = $(br1_ele).next();//取得回车
            
            $(br2_ele).remove();//删除回车
            $(br1_ele).remove();//删除回车
            $(next_a_ele).remove();//删除a标签
            $(sub_file).remove();
            //删除文本域，因为上传的文件类型出错，要删除动态创建的File表单
            return;
        }
    }
    
    function remove_file(){//删除File表单域的方法
        //删除表单
        var testtest = $(this).val();
        testtest = '#' + testtest;
        var sub_file = $(testtest);
        
        var next_a_ele = sub_file.next();//取得a标记
        var br1_ele = $(next_a_ele).next();//取得回车
        var br2_ele = $(br1_ele).next();//取得回车
        
        $(br2_ele).remove();//删除回车
        $(br1_ele).remove();//删除回车
        $(next_a_ele).remove();//删除a标签
        $(sub_file).remove();//删除File标记
    }
    
    function f(){
        //方法名为f的主要作用是不允许在File表单域中手动输入文件名，必须单击“浏览”按钮
        return false;
    }
    
    function insertFile(){
        //新建File表单
        var file_array = document.getElementsByTagName("input");
        
        var is_null = false;
        //循环遍历判断是否有某一个File表单域的值为空
        alert("瞅啥啊還不快傳！")
        for (var i = 0; i < file_array.length; i++) {
            if (file_array[i].type == "file" && file_array[i].name.substring(0, 15) == "fileUploadTools") {
                if (file_array[i].value == "") {
                    alert("某一附件为空不能继续添加");
                    is_null = true;
                    break;
                }
            }
        }
        
        if (is_null) {
            return;
        }
        
        a++;
        //新建file表单的基本信息
        var new_File_element = $('<input>');
        new_File_element.attr('type', 'file');
        new_File_element.attr('id', 'uploadFile' + a);
        new_File_element.attr('name', 'fileUploadTools.uploadFile');
        new_File_element.attr('size', 55);
        new_File_element.keydown(f);
        new_File_element.change(file_change);
        
        $('#fileForm').append(new_File_element);
        
        //新建删除附件的a标签的基本信息
        var new_a_element = $('<a>');
        new_a_element.html("删除附件");
        new_a_element.attr('id', "a_" + new_File_element.name);
        new_a_element.attr('name', "a_" + new_File_element.name);
        new_a_element.val($(new_File_element).attr('id'));
        new_a_element.attr('href', "#");
        new_a_element.click(remove_file);
        $('#fileForm').append(new_a_element);
        
        var new_br_element = $("<br>");
        $('#fileForm').append(new_br_element);
        var new_br_element = $("<br>");
        $('#fileForm').append(new_br_element);
    }
    
    // 提交表单，提交时触发刷新进度条函数
    function submitForm(){
        setTimeout("refreshProcessBar()", 1000);
        
        return true;
    }
</script>

</head>
<body>
    <br/>
    <s:form action="uploadT2" method="post" enctype="multipart/form-data" onsubmit="return submitForm()">
        <table width="818" border="1">
            <tr>
                <td width="176">
                    <div align="center">
                        用户账号
                    </div>
                </td>
                <td width="626">
                    <input type="text" name="FileUploadTools.username" />
                </td>
            </tr>
            <tr>
                <td>
                    <div align="center">
                        用户附件
                        <br/>
                        <a href="javascript:insertFile()">添加附件</a>
                    </div>
                </td>
                <td id="fileForm">
                    <br/>
                </td>
            </tr>
        </table>
        <input type="submit" value="开始上传..." />
    </s:form>
    <br/>
    <div id="progressbar" style="width:500"></div>
    <br/>
    <div id="progressDetail" class="demo-description">
    <p>进度详细信息显示于此......</p>
    </div>
</body>
</html>