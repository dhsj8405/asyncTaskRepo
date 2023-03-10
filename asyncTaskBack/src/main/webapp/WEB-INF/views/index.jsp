<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel = "stylesheet" href = "assets/css/index.css" type = "text/css">
<style type="text/css">
	
</style>
<script type="text/javascript" src="assets/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">

var tmp,params,bbsList = [],bbs;
var startPage,endPage,nowPage=1,pageCnt=3,limit=3,maxCnt;		//페이징 변수들
var srhForm,srhKey,srhWord;										//검색 변수들
var viewMode = "R"		//R:읽기 U:수정  I:쓰기
var ajaxErrMsg = "네트워크 오류입니다. 잠시후 다시 시도해주세요.";
$(function(){
	listPage = $('#main-page').html();
    detailPage =$('#bbs-modal').html();
    srhForm = $('#main-page form');
    $('#bbs-modal').hide();
    $('#warn-popup').hide();	
    $('#info-popup').hide();	
    $('#confirm-popup').hide();	
    
    /*
    	이벤트 핸들링
    */
    	// 키워드 검색시 
	    $(srhForm).on('submit',function(e){
	    	e.preventDefault();
	    	getList();
	    });
	    $(document).keydown(function(e) {
	    	
	        if ( e.keyCode == 27 ) {
	        	// esc버튼 클릭시 모달창 꺼짐
	        	if($('#bbs-modal').is(':visible') && $('#confirm-popup').is(':visible')){
	        		e.preventDefault();	
	        		$('#confirm-popup').hide();
	        	}else if($('#bbs-modal').is(':visible')){
	        		e.preventDefault();	
	        		$('#bbs-modal').hide();
	        	}
	        }
	        // 검색어 입력후 엔터시 리스트 조회
	        if(e.keyCode == 13 && $(srhForm).find(".word-span").find("input[name='word']").val() != ""){
	        	e.preventDefault();
	        	getList();
	        }
	    });
	    
	    // 게시물 모달
		    // 모달창 끄기
		    $('#bbs-modal').on('click',function(e){
		    	if(e.target.id == "bbs-modal")$('#bbs-modal').hide();// 모달 외 영역 클릭시 모달창 꺼짐
		    })
		    //x 버튼 클릭시 모달창 꺼짐
		    $('#bbs-modal .frame .header .close-btn-span').on('click',function(e){
		    	$('#bbs-modal').hide();		
		    })
		    //글 쓰기 버튼 클릭
		    $('#main-page .bbs-write-btn').on('click',function(e){
		    	e.preventDefault();
		    	viewMode = "I";
		    	fillByModal("");
		    	btnControl()
		    	$('#bbs-modal').show();
		    })
		    // 등록 버튼 클릭
		    $('#bbs-modal .btn-box a[name="ins-btn"]').on('click',function(e){
		    	e.preventDefault();
		    	var boo;
		    	boo = writeValid();
		    	if(boo)updateOne();
		    })
		    // 수정 버튼 클릭
		    $('#bbs-modal .btn-box a[name="mdfy-btn"]').on('click',function(e){
		    	e.preventDefault();
		    	viewMode = "U";
		    	btnControl();
		    })
		    // 취소 버튼 클릭
			$('#bbs-modal .btn-box a[name="can-btn"]').on('click',function(e){
		    	e.preventDefault();
		    	viewMode = "R";
		    	fillByModal(bbs);
		    	btnControl();
		    })
		    // 삭제 버튼 클릭
			$('#bbs-modal .btn-box a[name="del-btn"]').on('click',function(e){
		    	e.preventDefault();
		    	$('#confirm-popup').show()
		    })
		    // 삭제 버튼 클릭
			$('#bbs-modal .btn-box a[name="re-btn"]').on('click',function(e){
		    	e.preventDefault();
		    	console.log("dddd")
		    	//$('#confirm-popup').show()
		    })
	    //삭제 확정 팝업 
		    //삭제 확정 팝업 삭제클릭시
		    $('#confirm-popup .btn-box a[name="del-btn"]').on('click',function(e){
	   			deleteOne(bbs.num);
	   		});
		    //취소버튼 클릭시 모달 끄기
		    $('#confirm-popup .btn-box a[name="can-btn"]').on('click',function(e){
	   			$('#confirm-popup').hide();
	   		});
			// x버튼 클릭시 모달 끄기
		    $('#confirm-popup .frame .header .close-btn-span').on('click',function(e){
	   			$('#confirm-popup').hide();
	   		});
	    	
    // 리스트 조회     
    getList();
});
// bbs 리스트 조회
function getList(){
	srhKey = $(srhForm).find("select[name='key']").val();
	srhWord = $(srhForm).find(".word-span").find("input[name='word']").val();
	params = {
			srhKey : srhKey,
			srhWord : srhWord,
			limit: limit,
			nowPage : nowPage
	}
	$.ajax({
        url:'api/list.do'
        ,type:'get'
        ,data: params
        ,dataType:"json"
        ,success:function(resp){
        	if(resp.result == "SUCCESS"){
        		bbsList = resp.data;
        		maxCnt = parseInt(resp.strData);
        		drawMainPage(bbsList,maxCnt);
        	}else{
        		// 실패 알림창
            	warnModal(resp.resultMsg);	
        	}
        }
        ,error:function(xhr,msg,err){
        	warnModal(ajaxErrMsg);
        }
    });
}
// bbs 조회
function getOne(bbsNum){
	$('#content #bbs-modal .frame table  tr td input').attr("readonly", true); 
	$('#content #bbs-modal .frame table  tr td textarea').attr("readonly", true); 
	$.ajax({
        url:'api/detail.do'
        ,type:'get'
        ,dataType: "json"
        ,data: "bbsNum="+bbsNum
        ,success:function(resp){
        	if(resp.result == "SUCCESS"){
        		viewMode="R";
        		bbs = resp.data[0] 
            	fillByModal(bbs);
            	btnControl()
            	$('#bbs-modal').show();
            	
            	//조회수 증가로인한 리로딩
            	getList();	
        	}else{
        		// 실패 알림창
        		warnModal(resp.resultMsg);
        	}
        	
        },error:function(xhr,msg,err){
        	warnModal(ajaxErrMsg);
        }
    });
	
	/*
	bbs = bbsList.filter(function(ele){
		return ele.num == bbsNum
	})[0]
	$('#bbs-modal .sub').html(bbs.sub)
	$('#bbs-modal .reg-date').html(bbs.regDate)
	$('#bbs-modal .id').html(bbs.id)
	$('#bbs-modal .cnt').html(bbs.cnt)
	$('#bbs-modal .content').html(bbs.content)
	*/
}
//등록 수정
function updateOne(){
	var sub,id,content;
	sub = $('#bbs-modal .sub').val();
	id = $('#bbs-modal .id').val();
	content = $('#bbs-modal .content').val().replace(/(?:\r\n|\r|\n)/g, '<br/>');
	params = {
			sub : $('#bbs-modal .sub').val(),
			id : $('#bbs-modal .id').val(),
			content : $('#bbs-modal .content').val()
	}
	if(viewMode == "U")params.num = bbs.num ;
    $.ajax({
        url:viewMode == "I" ? 'api/insert.do' : 'api/update.do'
        ,type:'post'
        ,dataType: "json"
        ,data: params
        ,success:function(resp){
        	if(resp.result == "SUCCESS"){
        		viewMode="R";
        		bbs = resp.data[0];
            	fillByModal(bbs);
            	btnControl()
            	infoModal(resp.resultMsg);
            	getList();
        	}else{
        		warnModal(resp.resultMsg);
        	}
        }
        ,error:function(xhr,msg,err){
        	warnModal(resp.resultMsg);
        }
    });
}
//삭제
function deleteOne(bbsNum){
	$.ajax({
        url:'api/delete.do'
        ,type:'get'
        ,dataType: "json"
        ,data: {num : bbs.num}
        ,success:function(resp){
        	console.log(resp)
        	if(resp.result="SUCCESS"){
        		fillByModal("");
            	$('#bbs-modal').hide();
            	$('#confirm-popup').hide();
            	infoModal(resp.resultMsg);
            	getList();	
        	}else{
        		warnModal(resp.resultMsg);
        	}
        }
        ,error:function(xhr,msg,err){
            warnModal(network);
        }
    });
}

//메인 페이지 그리기
function drawMainPage(localBbsList){
	$('#main-page tbody').html("");
	drawBbsList(localBbsList);
    drawPaging();
}

// 메인 페이지의 bbs 리스트 그리기
function drawBbsList(localBbsList){
	 for(tmp of localBbsList){
	    	var row ="";
	    	row += "<tr class='bbs-row'>";
	    	row += "<td style='text-align:center;'>"+tmp.num+"</td>";
	    	row += "<td>"+tmp.sub+"</td>";
	    	row += "<td style='text-align:center;'>"+tmp.id+"</td>";
	    	row += "<td style='text-align:center;'>"+tmp.cnt+"</td>";
	    	row += "<td style='text-align:center;'>"+tmp.regDate+"</td>";
	    	row += "</tr>";
	    	$(row).appendTo('#main-page tbody');
	    }
	    $('.bbs-row').on('click',function(e){
			getOne($(e.target).parent().children().first().html());
		})	
}

// 메인 페이지의 페이징 부분 그리기
function drawPaging(){
	startPage = 1 + pageCnt * parseInt(((nowPage-1)/pageCnt));
 	endPage = startPage + pageCnt -1
 	if(endPage> maxCnt) endPage = maxCnt;

 	//페이징
    var rowBottom = "";
    rowBottom += "<tr>";
    rowBottom += "<td colspan='5' style='text-align:center'>";
    if(startPage!=1) rowBottom += "<span class='page-span'>Prev</span>";
    for(var i=startPage ; i<endPage+1 ; i++){
    	if(nowPage == i) rowBottom += "<span class='page-span page-span-sell'>"+(i)+"</span>";
    	else rowBottom += "<span class='page-span'>"+(i)+"</span>";
    }
    if(endPage < maxCnt) rowBottom += "<span class='page-span'>Next</span>";
    rowBottom += "</td>";
    rowBottom += "</tr>";
    $(rowBottom).appendTo('#main-page tbody');
    
    // 페이징 이벤트 등록
    $('.page-span').on('click',function(e){
    	nowPage = $(e.target).html()
    	
    	
    	if(nowPage === 'Prev') nowPage = startPage-1;
    	if(nowPage === 'Next') nowPage = endPage+1;
    	getList();
		
	})
}
//modal reset 및 set 함수

function btnControl(){
	// 버튼 처리
	if(viewMode == 'R'){
		$('#bbs-modal a[name="re-btn"]').show();
		$('#bbs-modal a[name="mdfy-btn"]').show();
		$('#bbs-modal a[name="del-btn"]').show();
		$('#bbs-modal a[name="ins-btn"]').hide();
		$('#bbs-modal a[name="can-btn"]').hide();
		
		$('#content #bbs-modal .frame table tr td input').attr("readonly", true); 
    	$('#content #bbs-modal .frame table tr td textarea').attr("readonly", true);
	}
	if(viewMode == 'U'){
		$('#bbs-modal a[name="ins-btn"]').show();
		$('#bbs-modal a[name="can-btn"]').show();
		$('#bbs-modal a[name="mdfy-btn"]').hide();
		$('#bbs-modal a[name="re-btn"]').hide();
		$('#bbs-modal a[name="del-btn"]').hide();
		
		$('#content #bbs-modal .frame table tr td input').attr("readonly", false); 
    	$('#content #bbs-modal .frame table tr td textarea').attr("readonly", false);
	}
	if(viewMode == 'I'){
		$('#bbs-modal a[name="ins-btn"]').show();
		$('#bbs-modal a[name="re-btn"]').hide();
		$('#bbs-modal a[name="mdfy-btn"]').hide();
		$('#bbs-modal a[name="del-btn"]').hide();
		$('#bbs-modal a[name="can-btn"]').hide();
		
		$('#content #bbs-modal .frame table tr td input').attr("readonly", false); 
    	$('#content #bbs-modal .frame table tr td textarea').attr("readonly", false);
	}
}
function fillByModal(localBbs){
	if(localBbs!= ""){
		//개행 복구
		if(localBbs.content.includes('<br/>'))
			localBbs.content = localBbs.content.split('<br/>').join("\r\n");	
	}
	// 내용 그리기
	$('#bbs-modal .sub').val(localBbs != "" ? localBbs.sub : "");
	$('#bbs-modal .reg-date').html(localBbs != "" ? localBbs.regDate : "");
	$('#bbs-modal .id').val(localBbs != "" ? localBbs.id : "");
	$('#bbs-modal .cnt').html(localBbs != "" ? localBbs.cnt : "");
	$('#bbs-modal .content').val(localBbs != "" ? localBbs.content : "");
}


// bbs 등록 및 수정시 유효성검사 함수
function writeValid(){
	var boo;
	sub = $('#bbs-modal .sub').val();
	id = $('#bbs-modal .id').val();
	content = $('#bbs-modal .content').val();
	if(sub === ""){
		warnModal("제목을 입력해주세요");
		boo = false;
	}else if(id === ""){
		warnModal("글쓴이를 입력해주세요");
		boo = false;
	}else if(content === ""){
		warnModal("내용을 입력해주세요");
		boo = false;
	}else boo =true;
	return boo;
}

function infoModal(msg){
	$('#info-popup>.frame>.content>div>label').html(msg)
	$('#info-popup').show()
	setTimeout(() => {
		$('#info-popup').hide()	
	}, 2000);
}
function warnModal(msg){
	$('#warn-popup>.frame>.content>div>label').html(msg)
	$('#warn-popup').show()
	setTimeout(() => {
		$('#warn-popup').hide()	
	}, 2000);
}

</script>
</head>
<body>
	
	<div id="content">
		<h1 id="home-btn">게시판 페이지</h1>
		<div id="main-page">
			<div class="srh-box">
			 	<form>
			 		<select name="key">
			 			<option value="sub" selected>제목</option>
			 			<option value="id">글쓴이</option>
			 			<option value="content">내용</option>
			 		</select>
			 		<span class="word-span">
			 			<input type="text" name="word">
			 		</span>
		 			<input class="srh-btn" type="submit" value="검색">
		 			
		 			<div class = "btn-box">
						<a class= "bbs-write-btn">글 쓰기</a>
					</div>
		 		</form>
		 		
			 </div>
			<table width="100%">
				<thead>
					<tr>
						<th width="5%">번호</th>
						<th width="40%">제목</th>
						<th width="10%">글쓴이</th>
						<th width="10%">조회수</th>
						<th width="15%">작성일</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		
		
		<div id = "bbs-modal">
			<div class="frame">
				<div class="header">
					<span class="close-btn-span">Ｘ</span>
	            </div>
				<table width="100%" align="center">
					<tr>
						<td width="100">제목</td>
						<td width="500"><input type="text" class="sub" name="sub"></td>
						<td width="100">작성일</td>
						<td width="500" class="reg-date"></td>
					</tr>
					<tr>
						<td width="100">글쓴이</td>
						<td ><input type="text" class="id"></td>
						<td width="100">조회수</td>
						<td class="cnt"></td>
					</tr>
					<tr>
						<td colspan="4"><textarea rows="5" cols="50" class="content" placeholder="내용입력"></textarea></td>
					</tr>
					<!-- 
					<tr>
						<td colspan="4" align="center">
							
						</td>
					</tr>
					-->
				</table>
				<div class="btn-box">
					<a class = "bbs-btn" name="del-btn">삭제</a>
					<a class = "bbs-btn" name="can-btn">취소</a>
					<a class = "bbs-btn" name="re-btn">답글</a>
					<a class = "bbs-btn" name="mdfy-btn">수정</a>
					<a class = "bbs-btn" name="ins-btn">등록</a>
				</div>
				<div class="reply-header">
					<input type="text" class="reply-id" name="reply-id"/>
					<input type="text" class="reply-content" name="reply-content"/>
					<a class = "bbs-btn" name="reply-ins-btn">등록</a>
				</div>
				<div class="reply-body">
						
				</div>
			</div>
		</div>
		
		<div id="warn-popup">
	        <div class="frame">
	            <div class="content">
		            <div>
		                <label>제목과 내용을 입력해주세요.</label>
		            </div>
	            </div>
	        </div>
	    </div>
		
		<div id="info-popup">
	        <div class="frame">
	            <div class="content">
		            <div>
		                <label>등록이 완료되었습니다.</label>
		            </div>
	            </div>
	        </div>
	    </div>
	    
    	<div id = "confirm-popup">
			<div class="frame">
				<div class="header">
					<span class="close-btn-span">Ｘ</span>
	            </div>
				<div class="content">
					<div>
		                <label>정말 삭제하시겠습니까 ?</label>
		            </div>
				</div>
				<div class="btn-box">
					<a class = "bbs-btn" name="del-btn">삭제</a>
					<a class = "bbs-btn" name="can-btn">취소</a>
				</div>
			</div>
		</div>
		
	</div>

</body>
</html>