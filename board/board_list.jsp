<%@ page language="java" contentType="text/html; charset=utf-8"%><%@ page
	import="java.util.*, java.text.SimpleDateFormat, net.board.db.*"%>
<%

BoardDAO boarddao=new BoardDAO();
List boardList = (List)request.getAttribute("boardlist");
int listcount=((Integer)request.getAttribute("listcount")).intValue();
int nowpage=((Integer)request.getAttribute("page")).intValue();
int maxpage=((Integer)request.getAttribute("maxpage")).intValue();
int startpage=((Integer)request.getAttribute("startpage")).intValue();
int endpage=((Integer)request.getAttribute("endpage")).intValue();
String category = (String)request.getAttribute("category");
String[] numberArr = new String[]{ "One" ,"Two" ,"Three" ,"Four" ,"Five" ,"Six" ,"Seven" ,"Eight" ,"Nine" ,"Ten" };
int nIdx = 0;
%>
<!--주석-->
<% if(session.getAttribute("id")==null) {%>
<script>
	alert("로그인해주세요");
	location.href = './index.jsp';
</script>
<%}else{%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<title>게시판</title>

<!-- Bootstrap core CSS -->
<link href="css/bootstrap.css" rel="stylesheet">

<!-- Add custom CSS here -->


<%@include file="../in_meta.jspf"%>


<!--Flat UI JS-->
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="js/jquery.ui.touch-punch.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-select.js"></script>
<script src="js/bootstrap-switch.js"></script>
<script src="js/flatui-checkbox.js"></script>
<script src="js/flatui-radio.js"></script>
<script src="js/jquery.tagsinput.js"></script>
<script src="js/jquery.placeholder.js"></script>


</head>
<!-- head 끝 -->
<body>
	<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<%@include file="../in_navibar.jspf"%>
	</nav>
	<div class="container">
		<!-- 게시판 설명 부분 -->
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">
					<%=boarddao.getCategoryName(category)%>
					게시판 <small>공통의 주제로 이야기 합니다</small>
				</h1>
				<ol class="breadcrumb">
					<li><a href="index.jsp">Home</a></li>
					<li class="active"><%=boarddao.getCategoryName(category)%> 게시판
					</li>
				</ol>
			</div>
			<!-- col-lg-12 -->
		</div>
		<!-- row -->

		<div class="form-group">
			<input type="text" class="form-control" placeholder="검색어 입력"
				onkeydown="if (event.keyCode == 13){ location.href =location.href.split('?')[0]+'?category=<%=category%>&keyword='+this.value; return false;} "
				style="display: inline-block; width: 300px; margin-right: 20px;" />
			<a href="./BoardWrite.bo?category=<%=category%>"> <span
				title="새 글 쓰기" class="fui-new"></span></a>
		</div>
		<div class="row">
			<table class="table table-striped table-hover ">
				<thead>
					<tr class="active">
						<th style="padding-left: 20px;">#</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성날짜</th>
					</tr>
				</thead>

				<!-- article 하나 -->
				<%
				if( listcount > 0 ){ // 글이 하나라도 잇는 경우
					for(int i=0;i<boardList.size();i++){
						BoardBean bl=(BoardBean)boardList.get(i); 
			%>

				<tbody>
					<tr>
						<td><a class="board-data"
							data-parent="#accordion" href="#collapse<%=numberArr[nIdx]%>">
								<%= bl.getB_NUM() %>
						</a></td>

						<%
						if( bl.getB_RE_LEV() != 0 ) {
							for(int a=0 ; a <= bl.getB_RE_LEV()*2 ; a++){ 
								out.println("&nbsp;"); // 답글 들여쓰기때문에
							}
							//out.println("-");
						} else { 
							//out.println("-");
						} 
			%>
						<td><a class="board-data"
							href="<%=request.getContextPath()%>/BoardDetailAction.bo?num=<%=bl.getB_NUM()%>&category=<%=bl.getCATEGORY() %>">
								<%=bl.getB_SUBJECT() %>
						</a></td>
						<td><a class="board-data"
							href="<%=request.getContextPath()%>/BoardDetailAction.bo?num=<%=bl.getB_NUM()%>&category=<%=bl.getCATEGORY() %>">
								<%=bl.getB_NAME() %>
						</a></td>
						<td><a class="board-data"
							href="<%=request.getContextPath()%>/BoardDetailAction.bo?num=<%=bl.getB_NUM()%>&category=<%=bl.getCATEGORY() %>">
								<%=bl.getB_DATE() %>
						</a></td>
					</tr>
					<div id="collapse<%=numberArr[nIdx]%>"
						class="panel-collapse collapse">
						<div class="panel-body">
							<%=bl.getB_CONTENT()%>
						</div>
					</div>



					<%-- 									<a data-role="button" class="accordion-toggle count" href="<%=request.getContextPath()%>/BoardDetailAction.bo?num=<%=bl.getB_NUM()%>&category=<%=bl.getCATEGORY() %>"> --%>
					<%-- 									<%=bl.getB_READCOUNT() %>  --%>
					<!-- 									</a> -->




					<%
						nIdx++;
					} // for - articles
			%>
				</tbody>
			</table>
		</div>
		<!-- end row -->




	</div>
	<!-- /.container -->
	<!-- 게시판 네비게이션 바 -->
	<div class="panel-heading board-navibar">
		<!--게시판 줄 번호-->
		<ul class="pagination">
			<li>
				<%
					if(nowpage<=1){ %>
			
			<li class="disabled"><a href="#fakelink" class="fui-arrow-left"></a></li>
			<%
					} else {
			%>
			<li class="previous"><a
				href="<%=request.getContextPath()%>/BoardList.bo?page=<%=nowpage-1 %>&category=<%=category%>"
				class="fui-arrow-left"></a></li>
			<%
					} // 현재 페이지가 끝인지 체크
			%>

			<%
					for ( int a = startpage ; a <= endpage ; a++){
						if(a==nowpage){ //현재 페이지라면
			%>
			<li class="active"><a><%=a %></a></li>
			<%
						} else {// 현재 페이지 번호가 아님
			%><li><a
				href="<%=request.getContextPath()%>/BoardList.bo?page=<%=a %>&category=<%=category%>"><%=a %>
			</a></li>
			<%
						} 
			%>
			<%
					} // 네이게이션 숫자 루프 끝
			%>

			<%
					if(nowpage>=maxpage){
			%>
			<li class="disabled"><a href="#fakelink" class="fui-arrow-right"></a></li>
			<%
					} else {
			%>
			<li class="next"><a
				href="<%=request.getContextPath()%>/BoardList.bo?page=<%=nowpage+1 %>&category=<%=category%>"
				class="fui-arrow-right"></a></li>
			<%
					} // 다음이 있는지 체크
			%>
			</li>

		</ul>
		<!--end 게시판 줄 번호-->
		<!-- <ul class="pagination">
                <li class="disabled"><a href="#">«</a></li>
                <li class="active"><a href="#">1</a></li>
                <li><a href="#">2</a></li>
                <li><a href="#">3</a></li>
                <li><a href="#">4</a></li>
                <li><a href="#">5</a></li>
                <li><a href="#">»</a></li>
              </ul> -->

	</div>
	<!-- /. 게시판 네비게이션 바 -->
	<%
				} // 리스트 항목이 1개 이상 존재 하면
			%>

	<!-- /.container -->
	<div class="container">
		<hr>
		<footer>
			<div class="row">
				<div class="col-lg-12">
					<p>Copyright &copy; Hit-IT 2014</p>
				</div>
			</div>
		</footer>
	</div>
	<!-- /.container -->

	<!-- JavaScript -->
	<script src="js/jquery-1.10.2.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="js/modern-business.js"></script>
</body>
</html>

<%}%>
