<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<style>
* {
	margin: 0;
	padding: 0;
}

ul, li {
	list-style: none;
}

a {
	text-decoration: none;
	color: inherit;
}

.layer {
	display: none;
	width: 100%;
	height: 100%;
	justify-content: center;
	align-items: center;
	background: rgba(0, 0, 0, 0.5);
	position: fixed;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
}

.layer .box {
	overflow: auto;
	width: 1500px;
	height: 90%;
	padding: 20px 20px 60px;
	margin: 20px;
	background: #fff;
	position: relative;
}

.layer .close {
    position: absolute;
    right: 0;
    width: 30px;
    display: block;
    top: 20px;
    cursor:pointer;
}

.layer:target {
	display: flex;
	animation: open 0.5s;
}

@
keyframes open {
	from {opacity: 0;
}

to {
	opacity: 1;
}

}

.rgt {
	text-align: center;
	display: block;
	position: absolute;
	right: 15px;
	top: 45%;
	cursor:pointer;
}

.lft {
	text-align: center;
	display: block;
	position: absolute;
	left: 15px;
	top: 45%;
	cursor:pointer;
}

.bcont_wrap {
	width : 100%;
	margin : 0 auto;
	justify-content: center;
}
.bcont_wrap div {
	width : 1000px;
	margin : 0 auto;
}
#bimg img {
	width: 100%
}

.e_wrap{
	width:100%;
	height: 100%;
	position: relative;
}


.b_param{
	position:relative;
	width:100%;
	height:100px;
	margin-bottom: 20px;
	border-bottom: groove;
}
#bdate{
	position: absolute;
	bottom: 10px;
	right: 200px;
}
#bdate::after{
    content: "~";
    font-size: 45px;
    position: absolute;
    bottom: 0px;
    right: -31px;
}

#edate{
	position: absolute;
	bottom: 10px;
	right: 80px;
}
#btitle{
    position: absolute;
    top: -7px;
    left: 400px;
    font-size: 30px;
    width: 500px;
}
.List_wrap{
	width: 1400px;
	height: 1000px;
	margin-left: auto;
	margin-right: auto;
	display: flex;
	flex-wrap: wrap;
    margin-top: 100px;
}

.ev{
	position : relative;
	display: flex;
	flex-flow: column;
	margin-left: 20px;
	margin-right: 20px;
	width: 300px;
	height: 350px;
    border: groove;
    text-align: center;
    overflow: hidden;
}
.ev>img{
	display: block;
	width: 295px;
	margin-left: auto;
	margin-right: auto;

}

.ev>.evtitle{
	position:absolute;
	display: block;
	width: 100%;
	text-align: center;
	bottom : 30px;
	background : #fff;
}
.evtdate{
	position:absolute;
	text-align: center;
	width : 100%;
	background : #fff;
	bottom : 0;
}
.evtdate>span{
    	display: inline-block;
}
#likey{
    position: absolute;
    left: 46px;
    top: 8px;
}
#likey-count{
    position: absolute;
    left: 91px;
    top: 4px;
    font-size: 15px;
}
.e_head{
	position: absolute;
    left: 906px;
    top: -60px;
}
.lft-p{
 	position: absolute;
 	left: 10px;
 	bottom: 800px;
}
.rgt-p{
	position: absolute;
	right: 10px;
	bottom: 800px;
}
</style>
<div class="e_wrap">
		<div class="e_head">
		<c:choose>
			<c:when test="${param.cate eq 2}">
				<h1>이벤트 리스트</h1>
			</c:when>
			<c:otherwise>
				<h1>지난 이벤트</h1>
			</c:otherwise>
		</c:choose>	
		</div>
	<div class="List_wrap">
			<c:forEach var="board" items="${list }">
			<div class="ev">
				<img alt="파일첨부해줘요잉" src="${board.board_file }">
				<!-- 이미지 첨부는 필수 -->
				<span class="evtitle" ><a href="#popup1" onclick="e_read(${board.board_number})">
				<b style="color:orange">[${board.board_store}점] </b>${board.board_title }</a></span>
			<div class="evtdate">
				<span >${board.board_bdate }</span> <span>${board.board_edate }</span>
			</div>	
			</div>	
			</c:forEach>
		</div>
	</div>
	
	
	<div id="popup1" class="layer">
		<div class="box">
			<a class="lft"><i class="xi-angle-left xi-2x"></i></a>
			<a class="rgt"><i class="xi-angle-right xi-2x"></i></a>
			<div class="b_param">
				<c:choose>
					<c:when test="${not empty login }">
						<i class="xi-heart-o xi-2x" id="likey" onclick="likey()"></i>
					</c:when>
					<c:otherwise>
						<i class="xi-heart-o xi-2x" id="likey" onclick="alert('로그인하셔야합니다.')"></i>
					</c:otherwise>
				</c:choose>
						<span id="likey-count">0</span>
				<span class="" id="btitle"></span>
				<span class="values" id="bdate"></span>
				<span class="values" id="edate"></span>
			</div>
			<div class="bcont_wrap">
				<div id="bimg" class=""></div>
				<div id="bcontent" class=""></div>
			</div>
			<a href="#" class="close"><i class="xi-close"></i></a>
		</div>
	
</div>
	




<div id="bnumber" style="display: none;"></div> <!--  지우면 안됨 다음 글 추출하는 파라미터 담는곳 -->
<div id="cate" style="display: none;">${param.cate }</div>
<script>
	
	const e1 = document.querySelectorAll('.e1')
	const b_param = document.querySelector('.b_param')
	const bcontent= document.getElementById('bcontent')
	const right = document.querySelector('.rgt')
	const left = document.querySelector('.lft')
	const bnum = document.getElementById('bnumber')
	const cate = document.getElementById('cate')
	let flag = false;
	
		function getCount(number){
		let url = '${cpath}/event/read/like/'+number
		let opt = {
				method : "GET"
		}
		fetch(url,opt)
		.then(resp=>resp.text())
		.then(text=>{
			if(!text == 0){
				document.getElementById('likey-count').innerText = text;
			}
		})
	}
	
	function e_read(number){
		getCount(number);
		already(number);
		let url = '${cpath}/event/read/'+number
		const opt = {method : 'GET' }
		fetch(url,opt)
		.then(resp => resp.json())
		.then(json => {
			console.log(json)
			const bnumber= document.getElementById('bnumber')
			const btitle= document.getElementById('btitle')
			const bdate= document.getElementById('bdate')
			const edate= document.getElementById('edate')
		
			
			for(key in json){
				switch(key){
					case 'board_number': bnumber.innerText = json[key]; break
					case 'board_title' : btitle.innerText = json[key]; break
					case 'board_bdate' : bdate.innerText = json[key]; break
					case 'board_content' : bcontent.innerHTML = json[key]; break
					case 'board_edate' : edate.innerText = json[key]; break
					default : break
				}
			}
		})
	}
	right.onclick = function(event){
		
		event.preventDefault()
		let url = '${cpath}/event/read/next/'+document.getElementById('bnumber').innerText+'/?cate='+cate.innerText
		const opt = {method : 'GET' }
		fetch(url,opt)
		.then(resp => resp.json())
		.then(json => {
			if(json !=null){
				bcontent.innerHTML = ""
					
				const bnumber= document.getElementById('bnumber')
				const btitle= document.getElementById('btitle')
				const bdate= document.getElementById('bdate')
				const edate= document.getElementById('edate')
				
			
				for(key in json){
					switch(key){
						case 'board_number': bnumber.innerText = json[key]; break
						case 'board_title' : btitle.innerText = json[key]; break
						case 'board_bdate' : bdate.innerText = json[key];  break
						case 'board_content' : bcontent.innerHTML = json[key]; break
								
						case 'board_edate' : edate.innerText = json[key]; break
						default : break
					}
				}
			}
				getCount(document.getElementById('bnumber').innerText);
				already(document.getElementById('bnumber').innerText);
		})
	}
		
	left.onclick = function(event){
		event.preventDefault()
		let url = '${cpath}/event/read/prev/'+document.getElementById('bnumber').innerText+'/?cate='+cate.innerText
		const opt = {method : 'GET' }
		fetch(url,opt)
		.then(resp => resp.json())
		.then(json => {
			if(json !=null){
				/* for(let i=0;i<childs.length;i++){
					childs[i].innerHTML=""
				} */
				bcontent.innerHTML = ""
					
				const bnumber= document.getElementById('bnumber')
				const btitle= document.getElementById('btitle')
				const bdate= document.getElementById('bdate')
				const edate= document.getElementById('edate')
				
			
				for(key in json){
					switch(key){
						case 'board_number': bnumber.innerText = json[key]; break
						case 'board_title' : btitle.innerText = json[key]; break
						case 'board_bdate' : bdate.innerText = json[key]; break
						case 'board_content' : bcontent.innerHTML = json[key];break
						case 'board_edate' : edate.innerText = json[key]; break
						default : break
					}
				}
			}
			getCount(document.getElementById('bnumber').innerText);	
			already(document.getElementById('bnumber').innerText);
		})
	}

	const BL=document.getElementById('likey');
	
	
	
	
	

	
	
	function already(number){
		if('${login.member_email}'==''){return;}
		const url = '${cpath}/event/read/already/?board_number='+number+'&user_email=${login.member_email}'
		const opt = {
				method : "GET"
		}
		fetch(url,opt)
		.then(resp => resp.text())
		.then(text=>{
			if(text == 1){
				BL.setAttribute('class','xi-heart xi-2x')
			}else{
				BL.setAttribute('class','xi-heart-o xi-2x')
			}
		})
	}

	
	function likey(){
		if(BL.getAttribute('class')=="xi-heart xi-2x"){
			delikey();
			return;
		}
		
		const obj={
				board_number :bnumber.innerText,
				user_email :'${login.member_email}'
		}
		const url='${cpath}/event/like/'
		const opt={
				method : "POST",
				body : JSON.stringify(obj),
				headers: {
					'Content-Type' : 'application/json; charset=utf-8'
				}
		}
		fetch(url,opt).then(resp=>resp.text())
		.then(text=>{
				console.log(text)
				if(text != 'n'){
				BL.setAttribute('class','xi-heart xi-2x')
				document.getElementById('likey-count').innerText = text;
			}
		})
	}
	
	function delikey(){
		if(BL.getAttribute('class')=="xi-heart-o xi-2x"){
			likey();
			return;
		}
		const obj={
				board_number :bnumber.innerText,
				user_email :'${login.member_email}'
		}
		const url='${cpath}/event/like/'
		const opt={
				method : "DELETE",
				body : JSON.stringify(obj),
				headers: {
					'Content-Type' : 'application/json; charset=utf-8'
				}
		}
		fetch(url,opt).then(resp=>resp.text())
		.then(text=>{
				console.log(text)
				if(text != 'n'){
				BL.setAttribute('class','xi-heart-o xi-2x')
				document.getElementById('likey-count').innerText = text;
			}
		})
	}

</script>



<%@include file="../footer.jsp"%>