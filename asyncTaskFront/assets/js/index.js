
var tmp,params,bbsList = [],bbs;
var startPage,endPage,nowPage=1,pageCnt=3,limit=5,maxCnt;		//페이징 변수들
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
			// 5개,10개보기
			$('#main-page .limit-btn-5').on('click',function(e){
		    	e.preventDefault();
				limit = 5;
				getList();
		    })
			$('#main-page .limit-btn-10').on('click',function(e){
		    	e.preventDefault();
				limit = 10;
				getList();
		    	
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
	console.log("??")
	
	$.ajax({
        url:'http://localhost:8080/api/list.do'
        ,type:'get'
        ,data: params
        ,dataType:"json"
        ,success:function(resp){
			console.log("응답")
			console.log(resp)
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
        url:'http://127.0.0.1:8888/api/detail.do'
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
        url:"http://127.0.0.1:8888/" +(viewMode == "I" ? 'api/insert.do' : 'api/update.do')
        // ,type:'post'
		,type: 'post'
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
        url:'http://127.0.0.1:8888/api/delete.do'
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
            warnModal(ajaxErrMsg);
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
