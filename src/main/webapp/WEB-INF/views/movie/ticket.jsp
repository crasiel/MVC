<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<script>

</script>
<section id="movieWrap">
        <div class="ticket"> 
             <nav class="nav" id="choice1">  
                 <h1 class="text">영화관</h1>     
                  <ul>
                      <li><p>부산</p>
                        <ul class="sub">
                            <li>서면점</li>
                            <li>해운대점</li>
                            <li>남포점</li>
                            <li>동래점</li>
                        </ul>
                    </li>
                    <li><p>서울</p>
                        <ul class="sub">
                            <li>강남점</li>
                            <li>홍대점</li>
                            <li>명동점</li>
                            <li>구로점</li>
                        </ul>
                    </li>
                    <li><p>그외지역</p>
                        <ul class="sub">
                            <li>김해점</li>
                            <li>대구점</li>
                            <li>광주점</li>
                            <li>전주점</li>
                            <li>천안/아산</li>
                            <li>강릉점</li>
                        </ul>
                    </li>
                </ul>
            </nav>
            
            <nav class="nav" id="choice2">
                <h1 class="text">영화선택</h1>
	            
	            <ul id="theater_info_movie">
	            </ul>
               
            </nav>
            
        <div class="nav" id="choice3">
            <div class="text">날짜/시간선택</div>
            <ul id="dateForm"></ul>
            
            <div id="movieList">
            
            
                불러온 영화 목록 띄우기          
            </div>
    
        </div>
        </div>
        
        <div class="btn1" onclick="goSeat()">좌석선택하기</div>
    </section>
    
    
    
    
    
    
    
    <script>
    
    var sdate ='';
    var movie_title='';
    var screen_code = '';
    
    var cbranch='';
    var cmovie='';
    var cday='';
    var arrtitle = '';
    
        $('#choice1 p').on('click', function(){
            $(this).css({
               'border':'1px dotted #ccc',
                'color' : 'red',
                'background':'#fff',
                'font-weight':'bold'
            }).parent().siblings().find('p').css({
                'border':'none',
                'color' : '#000',
                'background':'#eee',
                'font-weight':'normal'
            });
            
            $(this).siblings('.sub').stop().show().parent().siblings().find('.sub').stop().hide();
        })
        
        $('#choice1 .sub li').on('click', function(){
	        const theater_info_movie = document.getElementById('theater_info_movie')
        	theater_info_movie.innerText = ''
            $(this).css({
               'border':'1px dotted #ccc',
                'color' : 'red',
                'font-weight':'bold'
            }).siblings().css({
                'border':'none',
                'color' : '#000',
                'font-weight':'normal'
            });
            
            const t= $(this).text();
            cbranch = t;
            console.log(t.slice(0,-1))
            branch = t.slice(0, -1)
			const url = "${cpath}/movie/movieList?branch=" + branch; 
	   		const opt ={
	   				method : 'GET'
	   		}
	   		fetch(url, opt)
	   		.then(resp => resp.json())
	   		.then(json => {
   			console.log(json)
			for(let i=0; i < json.length; i++){
				const li = document.createElement('li')
				li.className = "movie_list"
				const ob = json[i];
	
				for(let key in ob) {
					//console.log(ob[key])
					if(ob[key] != null){
	   					const value = ob[key]
						if(key != 'runtime'){
	    					const span = document.createElement('span')
	    					
	    					
	    					if(key == 'movie_audit'){			
								switch(value){
								case '전체관람가': span.innerHTML = 'All';
									span.style.background = 'green';
									break;
								case '12세이상관람가': span.innerHTML  = '12세' ; 
									span.style.background = 'blue';
									break;
								case '15세이상관람가': span.innerHTML  = '15세' ;
									span.style.background = 'orange';
									break;
								case '청소년관람불가': span.innerHTML  = '청불' ;
									span.style.background = 'red';
									break;
								default : break;
								}
	    					}else{
	    						span.className = key
	    						/* if(value.length >= 18 && value.length < 25){
	    							span.innerHTML = '<b style="font-size:14px;">'+value+'</b>'
	    						}else if(value.length >= 25){ */
	    						if(value.length >= 18){			// 제목이 크거나, 시리즈 : 부제 있는 경우 ':' 기준으로 잘라서 제목 입력
	    							var arr = value.split(':')
	    							span.innerHTML = '<b style="display : inline-block;font-size:16px; line-height : 18px;">'+ arr[0] +":"
	    											+ '<br>' + '<span style="font-size : 12px; line-height : 12px; color : darkblue">' + arr[1] +'</span></b>'
	    							
	    						}else{
	    							span.innerHTML = '<b>'+value+'</b>'
	    						}
	    						
	    					}
	    					li.appendChild(span)
							theater_info_movie.appendChild(li)
							
	    					}
						}
					}
				}
   			List();
	  		})
	            
	            
	        })
        
        
        $(document).on('click', '#choice2 li', function(){
            $(this).css({
               'border':'1px dotted #ccc',
                'color' : 'red',
            }).siblings().css({
                'border':'none',
                'color' : '#000',                
            });
            const t2= $(this).find('span').text();
            cmovie= $(this).find('b').text();

            List();
        })

    </script>
    
    
    <script>
        var dateForm = document.getElementById('dateForm')
               
        const date = new Date()
        const week = ['일','월','화','수','목','금','토']
        var day = date.getDate()				// 날짜
        var w = date.getDay()					// 주간 0 ~ 6 (일~토)과 week 변수 => 요일 생성
		var month = date.getMonth()+1			// 월 0~11 이므로 + 1 해준다
        for(let i = 0; i < 7; i++){
            
            const li = document.createElement('li')
            const p1 = document.createElement('p')
            const span = document.createElement('span')
            
            if(w == 6){
                li.setAttribute("style", "color:blue")
            }else if(w == 7){
                w = 0
                li.setAttribute("style", "color:red")
            }
            p1.textContent = ("0" + month).slice(-2) +  ("0" + day).slice(-2);
/*             if(month < 10){
            	if(day < 10){
	            	p1.textContent = '0' + month + '0' + day      //월과 일을 같이 표시하고 싶으면 그렇게 하기
            	}else if(day >= 10){
	            	p1.textContent = '0' + month  + day      //월과 일을 같이 표시하고 싶으면 그렇게 하기
            	}
            }else{
            	if(day < 10){
    	            p1.textContent =  month + '0' + day      //월과 일을 같이 표시하고 싶으면 그렇게 하기
               	}else if(day >= 10){
    	            p1.textContent = month  + day      //월과 일을 같이 표시하고 싶으면 그렇게 하기
                	}
            } */
            span.textContent = week[w]
            
            switch(month){	// 월 바뀔때마다 날짜 초기화
            case 2: if(day==28) {day=0; month++};break;
            case 4:;case 6:;case 9:;
            case 11:if(day==30) {day=0; month++}; break;
            case 1:;case 3:;case 5:;case 7:;case 8:;case 10:;
            case 12:if(day==31) {day=0; month++};break;    
   			 }
            w++
            day++
            console.log(day)
            li.appendChild(p1)
            li.appendChild(span)
            dateForm.appendChild(li)
        }
        
        
    </script>
    
    <script>
    $('#dateForm li').on('click', function(){
        $(this).siblings().removeClass()
        $(this).addClass('on')
        const movieList = document.getElementById('movieList')
        const t3 = $(this).find('p').text()
        console.log(t3)
        cday =t3;
        List();
    });
    
    function List(){
		const movieList = document.getElementById('movieList')
    	if(cbranch==''||cmovie==''||cday==''){console.log('bye'); return;}
		movieList.innerHTML='';
		const ul = document.createElement('ul')
		const url = "${cpath}/movie/dateList?date=" + cday+"&branch="+cbranch.slice(0,-1)+"&movie_title="+cmovie; 
   		const opt ={
   				method : 'GET'
   		}
   		fetch(url, opt)
   		.then(resp => resp.json())
   		.then(json => {
		for(let i=0; i < json.length; i++){
			const li = document.createElement('li');
			li.className = "date_list";
			li.innerHTML = "<span>"+json[i].screen_code+" " +"</span>"+"<span>"+json[i].movie_title+" "+"</span>"+"<span> 시작시간 : "+json[i].start_time+" " +"</span>"+"<span>전체좌석: "+json[i].seat_amount+" " +"</span>"
			ul.appendChild(li)
			movieList.appendChild(ul)
			li.style.cursor='pointer';
			}
  		})
    	
    }
    $(document).on('click','.date_list', function () {
    	const text1 = $(this).find('span').eq(0).text()
    	const text2 = $(this).find('span').eq(1).text()
    	const text3 = $(this).find('span').eq(2).text()
    	const text4 = $(this).find('span').eq(3).text()
    	screen_code = text1.replaceAll(' ','')
    	movie_title = text2.replaceAll(' ','')
    	sdate = text3.split(':')[1].replaceAll(' ','')
    	seat_amount = text4.split(':')[1].replaceAll(' ','')
    	$('.date_list').css({
    		'border' : 'none',
    		'color' : '#000'
    	})
    	$(this).css({
    		'border' : '1px solid #000',
    		'color' : 'red'
    	})
    })
        
    
    function goSeat(){
    	if(screen_code==''||sdate==''||movie_title==''||seat_amount==''){alert('영화관,영화 및 날짜를 선택하지 않으셨습니다.');return;}
    	location.href = "${cpath}/movie/ticket2?branch="+screen_code+"&movie="+movie_title+"&day="+cday+"/"+sdate+"&seat_amount="+seat_amount
    }
    
    </script>


<%@ include file = "../footer.jsp" %>