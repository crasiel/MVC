<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<section id="bodyWrap">
		
	<div class="noticeWrap" style="padding : 10px;">
	<h2 style="font-weight: bold; margin : 0 30px;text-decoration: underline; ">지점/영화선택</h2>
	<div class="infoWrap">
   <form method="post" id="Theater_info">
        <p>	    
            <select name="branch" onchange="javascript:myListener(this)">
	        		<option>지점을 선택해 주세요.</option>
	        	<optgroup label="서울">
	        		<option value ="강남">강남점</option>
	        		<option value ="홍대">홍대점</option>
	        		<option value ="명동">명동점</option>
	        		<option value ="구로">구로점</option>
	        	</optgroup>
	        	<optgroup label="부산">
	        		<option value ="서면">서면점</option>
	        		<option value ="해운대">해운대점</option>
	        		<option value ="남포">남포점</option>
	        		<option value ="동래">동래점</option>
	        	</optgroup>
	        	<optgroup label="그외지역">
	        		<option value ="김해">김해점</option>
	        		<option value ="대구">대구점</option>
	        		<option value ="광주">광주점</option>
	        		<option value ="전주">전주점</option>
	        		<option value ="천안/아산">천안/아산</option>
	        		<option value ="강릉">강릉점</option>
	        	</optgroup>
	        </select>
        </p>
        <p>
			<select id="screen_code" name="screen_code" onchange="javascript:screenList(this)">
				<option>상영관을 선택해 주세요.</option>
			</select>        
        </p>
        <p>
			<select id="movie_title" name="movie_title" onchange="changeMovieNm()">
				<option>영화를 선택해 주세요.</option>
			</select>        
        </p>
        
        <div id="screenList">
        <h2 style="font-weight: bold; margin : 0 0 10px 20px; text-align:left; text-decoration: underline; ">상영예정목록</h2>
<!--         	screen_code 에 해당하는 모든 시간 list 가져오기 -->
			<div class="Movielist">
					<span class="runtime" id="runtime">[영화제목]</span>
					<span class="start_date" id="start_date">[상영시작일]</span>
					<span class="end_date" id="end_date" >[상영마감일]</span>
					<span class="start_time" id="start_time">[시작시간]</span>
					<span class="end_time" id="end_time">[마감시간]</span>
					<span class="runtime" id="runtime">[러닝타임]</span>
			</div>
        	<div class="movie_Tlist">
        	</div>
        </div>
        
        <div id="movieInfo">
            <h2 style="font-weight: bold; margin : 0 20px;text-decoration: underline; ">상영시간 추가</h2>
            

	        <p>
				<input type="date" name="start_date" required>   	
	        </p>
	        <p>
				<input type="date" name="end_date" required>   	
	        </p>
            <p>
				<select name="movie_type">
					<option value="2">2D</option>
					<option value="3">3D</option>
				</select>        
    		</p>
	        
	        
        </div>   
			<input type="time" name="start_time" required style="width : 280px; height: 40px; line-height: 40px;">
<!--        
	필요한 컬럼, movie_code, start_date, end_date, movie_type
 현재 상영 영화 api 로 가져와서 런타임이랑 몇가지 정보 받아오기 시간 입력해서 theater_info 에 넣기  이름, showTm 뒤 25분 여유
			해당 스크린의 occupy time list 를 전부 띄워주기 -->
			
        <p><input type="submit" class="btn2" value="영화시간입력" style="width : 200px;"></p>
    </form>
    </div>
 </div>
 </section>
  
    
<script>
// 	영화시간 입력 버튼 onclick
document.forms.Theater_info.onsubmit = function(event){
	event.preventDefault()
	const formData = new FormData(event.target)	
	console.log(formData)
	const url = "${cpath}/admin/cinema/insertTheaterInfo"
		const opt = {
			method: 'POST',
			body: formData,
		}
	fetch(url, opt)
	.then(resp => resp.text())
	.then(text => {
		console.log(text)
		if(+text == 1){
			alert("상영시간을 입력하였습니다.")
			location.href = "${cpath}/admin/cinema/insertTheaterInfo"
		}else{
			if(+text == 0){
				alert("입력 시간을 확인해 주세요.")
			}else{
				alert("영화 상영시간이 중복됩니다.")
			}
		}
	})
	
}




// 영화를 선택해 주세요 select option 에 영화 list 추가
	const key = "0c5277606b20ef880a6c3aec340bb83b"

	const test1 = '${dailyMovie }'
	const test2 = JSON.parse(test1)
	const movie_title = document.getElementById("movie_title")
	const div = document.createElement('div')
	
	for(let i = 0;i< test2.boxOfficeResult.dailyBoxOfficeList.length ; i++ ){
		const movieName = test2.boxOfficeResult.dailyBoxOfficeList[i].movieNm
		const movieCode = test2.boxOfficeResult.dailyBoxOfficeList[i].movieCd
   		const movieCd = encodeURI(movieCode);
   		
   		const url = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=" +key +"&movieCd=" + movieCd; 
   		const opt ={
   				method : 'GET'
   		}
   		fetch(url, opt)
   		.then(resp => resp.json())
   		.then(json => {
   			const movie_name = json.movieInfoResult.movieInfo.movieNm
// 			console.log(movie_name)
			appendMovie(movie_name)
   		})
   		
	}
	
	
	function appendMovie(movie_name){
       	const option = document.createElement('option')
       	option.innerText = movie_name
       	movie_title.appendChild(option)
    }
	
	
	
	
	function changeMovieNm(){
		const movieSelect = document.getElementById("movie_title");

		const selectValue = movieSelect.options[movieSelect.selectedIndex].value;
		
// 		console.log(selectValue)
		  
		for(let i = 0;i< test2.boxOfficeResult.dailyBoxOfficeList.length ; i++ ){
			const movieName = test2.boxOfficeResult.dailyBoxOfficeList[i].movieNm
			const movieCode = test2.boxOfficeResult.dailyBoxOfficeList[i].movieCd
			if(movieName == selectValue){
				const movieCd = encodeURI(movieCode)
				const url = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=" +key +"&movieCd=" + movieCd; 
		   		const opt ={
		   				method : 'GET'
		   		}
		   		fetch(url, opt)
		   		.then(resp => resp.json())
		   		.then(json => {
		   			const movie_name = json.movieInfoResult.movieInfo.movieNm
		   			const movie_runtime = json.movieInfoResult.movieInfo.showTm
					const movieAudit = json.movieInfoResult.movieInfo.audits[0].watchGradeNm
// 		   			console.log(json)
// 		   			console.log(movieAudit)
					div.innerHTML=''
					const span1 = document.createElement('span')
					const span2 = document.createElement('span')
					const hidden1 = document.createElement('input')
					const hidden2 = document.createElement('input')
					const hidden3 = document.createElement('input')
					const hidden4 = document.createElement('input')
					const b1 = document.createElement('b')
					const b2 = document.createElement('b')
					span1.appendChild(b1)
					span2.appendChild(b2)
					
					hidden1.type = 'hidden'
					hidden1.name = 'movie_code'
					hidden1.value = movieCode
					
					hidden2.type = 'hidden'
					hidden2.name = 'movie_name'
					hidden2.value = movie_name
					
					hidden3.type = 'hidden'
					hidden3.name = 'runtime'
					hidden3.value = movie_runtime

					hidden4.type = 'hidden'
					hidden4.name = 'movie_audit'
					hidden4.value = movieAudit
					
					b1.innerHTML = "movie_title : " + movieName +"<br>"
					b2.innerHTML = "runtime : " + movie_runtime
					
					div.appendChild(span1)
					div.appendChild(span2)
					div.appendChild(hidden1)
					div.appendChild(hidden2)
					div.appendChild(hidden3)
					div.appendChild(hidden4)
		   			
		   		})
			document.getElementById('movieInfo').appendChild(div)
		   		
			}
		}
	  }

		
</script>    
    
<script>

	function screenList(obj){
		const screenName = obj.value
// 		console.log("screenName : "+screenName)
		const movie_Tlist = document.querySelector('.movie_Tlist')
		
		if(document.querySelector('.movie_list') != null){
			movie_Tlist.innerText = ""		
		}
		
		const url = '${cpath}/admin/cinema/getScreenCodes/' + screenName
		const opt = {
    			method: 'get'
    		}
    		fetch(url, opt)
    		.then(resp => resp.json())
    		.then(json => {
    			
    	        
//      			console.log(json)
//     			console.log(Object.keys(json).length)
    			
    			for(let i=0; i < json.length; i++){
   					const div = document.createElement('div')
					div.className = "movie_list"
   					const ob = json[i];
    				for(let key in ob) {
    					console.log(ob[key])
    					if(ob[key] != null){
	    					const value = ob[key]
	    					const span = document.createElement('span')
	    					span.className = key
	    					span.innerText = value
	    					div.appendChild(span)
    					}
    					movie_Tlist.appendChild(div)
    				}
    			}
    			
    		})
		}


</script>
    
    
<!--     select opt script -->
<script>
	function myListener(obj) {
		
		const screen_code = document.getElementById("screen_code")
        screen_code.options.length = 0;
// 		console.log("screen_code : "+screen_code)
        const branch = obj.value
        
    	const url = '${cpath}/admin/cinema/screenCodes/' + branch
		const opt = {
    			method: 'get'
    		}
    		fetch(url, opt)
    		.then(resp => resp.json())
    		.then(json => {
//     			console.log("Ajax text : " +json)
        const screen_codes ={
            	a: json,
            	b: json,
            	c: json,
            	d: json,
            	e: json,
            	f: json,
            	g: json,
            	h: json,
            	i: json,
            	j: json,
            	k: json,
            	l: json,
            	n: json,
            	m: json,	
            	
            }
    			
       	let list = {};

        switch(branch){
        case '강남':
        	list = screen_codes.a;
        	appendList(list);break;
        case '홍대':
        	list = screen_codes.b;
        	appendList(list);break;
        case '명동':
        	list = screen_codes.c;
        	appendList(list);break;
        case '구로':
        	list = screen_codes.d;
        	appendList(list);break;
        case '서면':
        	list = screen_codes.e;
        	appendList(list);break;
        case '해운대':
        	list = screen_codes.f;
        	appendList(list);break;
        case '남포':
        	list = screen_codes.g;
        	appendList(list);break;
        case '동래':
        	list = screen_codes.h;
        	appendList(list);break;
        case '김해':
        	list = screen_codes.i;
        	appendList(list);break;
        case '대구':
        	list = screen_codes.j;
        	appendList(list);break;
        case '광주':
        	list = screen_codes.k;
        	appendList(list);break;
        case '전주':
        	list = screen_codes.l;
        	appendList(list);break;
        case '천안/아산':
        	list = screen_codes.n;
        	appendList(list);break;
        case '강릉':
        	list = screen_codes.m;
        	appendList(list);break;
        }
        
    		})
        
   
        
        function appendList(list){
           	list.unshift('상영관을 선택해 주세요.')
	        for(let i = 0; i < list.length; i++){
	        	const option = document.createElement('option')
// 	        	console.log("list"+[i]+": "+list[i])
	        	option.innerText = list[i]
	        	screen_code.appendChild(option)
       	 }
        }
        
        
        
    }
    
 
    
   
    
</script>


<%@include file="../footer.jsp" %>