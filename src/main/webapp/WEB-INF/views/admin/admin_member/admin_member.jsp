<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>

<script>
// 주소 api
function goPopup(){
	var pop = window.open("${cpath}/admin/addrPopup","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}


function jusoCallBack(roadAddrPart1, addrDetail){
	var addrEl = document.querySelector('input[name="admin_addr"]')
	addrEl.value = roadAddrPart1 +',' +addrDetail 
	
}
</script>

<script>
//leftMenu 클릭시
/* 
 function tab(t){
//  var name = ".con" + t
  var choice =  document.querySelector('.con'+t)

  var all = document.querySelectorAll('.rightWrap>div')
  for(var i =0; i < all.length;i++){
      all[i].style.display = "none"
  }
  choice.style.display="block"  
  
}

 */
// ------leftMemnu && update ------
function tab(t, admin_num){
	 //update 처리
	if((t != null) && (admin_num != null)){
		const updateForm = document.getElementById('updateForm')
	  	console.log(admin_num) // 클릭할 사원번호가 받아와지는지 확인
	  
		const url = '${cpath}/admin/admin_member/' + admin_num
		const opt = {method:'GET'}
		fetch(url, opt)
		.then(function(resp){return resp.json()})
		.then(function(json) {
			updateForm.innerHTML = ''
			/* updateForm.innerHTML = '<input type="button" onClick="goPopup()" class="btn1" value="주소검색">' */
			for(key in json){
				console.log(key, ':', json[key])
				const div = document.createElement('div');
					const span = document.createElement('span');
					const input = document.createElement('input');
					
					switch(key){
					case 'admin_num' :  span.innerText ='사원번호'; input.readOnly = 'readonly';updateForm.appendChild(span); input.readOnly; break;
					case 'admin_password': input.type='hidden'; break;
					case 'deleted' : input.type='hidden'; break;
					case 'admin_name' :  span.innerText ='성명'; break;
					case 'admin_phone' :  span.innerText ='전화번호'; break;
					case 'admin_addr' :  span.innerText ='주소'; break;
					case 'admin_phone' :  span.innerText ='전화번호'; break;
					case 'admin_jday' : span.innerText ='입사일'; input.type = 'date'; break;
					case 'admin_lday' : span.innerText ='퇴사일'; input.type = 'date'; break;
					case 'admin_store' :  span.innerText ='근무지점'; break;
					case 'admin_dept' : span.innerText ='직급'; 
										const select = document.createElement('select');
											select.name = key;
											select.innerHTML='<option value="1">총괄관리자</option><option value="2">지점장</option><option value="3">매니저</option><option value="4">사원</option>'
											const options = select.querySelectorAll('option')
											switch(json[key]){
											case '1' :  options[0].selected = true;  options.text='총괄관리자';  break;
											case '2' :	options[1].selected = true; options.text='지점장';break;
											case '3' :	options[2].selected = true; options.text='매니저';break;
											case '4' :	options[3].selected = true; options.text='사원';break;
											}
											div.appendChild(select)
										break;
										
					default : input.type='text';break;
					}
					/* span.innerText = key; */
					
					 
					if(key != 'admin_dept'){
						input.name = key;
						input.value = json[key]; 
						div.appendChild(input)
					}
					if(span.innerText != ''){
						div.appendChild(span)
					}
					updateForm.appendChild(div)	
			}	
			/* <input type="button" onClick="goPopup()" class="btn1" value="주소검색"> */
			
			const submit = document.createElement('input');
			submit.type='submit';
			submit.value='정보수정'
			submit.className = 'btn3'
			updateForm.appendChild(submit);
		})
		
		updateForm.onsubmit = function(e){
			e.preventDefault();
			const formData = new FormData(e.target);
			const url = '${cpath}/admin/admin_member/update'
			const opt = {
					method:'POST',
					body:formData
			}
			
			fetch(url, opt)
			.then(resp => resp.text())
			.then(text => {
				if(+text == 1){		
					alert('정보수정 완료!')
					location.reload()
				}else{
					alert('정보수정 실패!')
				}
			})
		}
	}
  
var choice =  document.querySelector('.con'+t)
  var all = document.querySelectorAll('.rightWrap>div')
  for(var i =0; i < all.length;i++){
	  all[i].classList.remove('on')
      
  }
  choice.classList.add('on')
    
	
}
</script>
<section id="bodyWrap">

        <div class="leftWrap">
            <ul>
                <li onclick="tab(1)">사원목록</li>
                <li onclick="tab(2)">사원입력</li>
                <li onclick="tab(3)">퇴사자관리</li>
            </ul>
        </div>

        <div class="rightWrap">
            <div class="con1 on" >				<!--  사원 리스트  -->
                <h2>사원목록</h2>
                <c:if test="${empty list }">
                	<h2>사원 목록이 없습니다.</h2>
                </c:if>
                <c:if test="${not empty list }">
	                <div class="list-title cf">
	                	<span>사원번호</span>
	                	<span>지점</span>
	                	<span>직급</span>
	                	<span>사원명</span>
	                	<span>입사일</span>
	                	<span>연락처</span>
	                	<span>주소</span>
	                </div>
	                <div class="list cf">
	                <c:forEach var="a" items="${list}"> 
	                <c:if test="${a.deleted eq 'n' }"> 
					<p onclick="tab(4, ${a.admin_num})">
	                	<span>${a.admin_num}</span>
	                	<span>${a.admin_store}</span>
	                	<span>
							<c:choose>
								<c:when test="${a.admin_dept  == 1 }">
											총괄관리자
								</c:when>
								<c:when test="${a.admin_dept  == 2}">
											지점장
								</c:when>	
								<c:when test="${a.admin_dept == 3 }">
											매니저
								</c:when>	
								<c:when test="${a.admin_dept == 4 }">
											사원
								</c:when>		
							</c:choose>
						</span>
						<span>${a.admin_name}</span>
						<span>${a.admin_jday}</span>
						<span>${a.admin_phone}</span>		
						<span>${a.admin_addr}</span>
						</p>
						</c:if>	
					</c:forEach>
					<!-- <article>
						<c:if test="${paging.prev }">
						   	<a href="${cpath }/admin/admin_member?page=${paging.begin-1}">
						   	[이전]</a>
					   	</c:if>
						<c:forEach var="i" begin="${paging.begin }" end="${paging.end}">
							<span onclick="name(${i})">[${i}]</span>
						</c:forEach>
						<c:if test="${paging.next }">
						   	<a href="${cpath }/admin/admin_member?page=${paging.end+1}">
						   	[다음]</a>
					   	</c:if>
					</article> -->
					</div>
					
				</c:if>
            </div>
            
            <div class="con2">								<!-- 사원계정 생성 -->
                <h2>사원입력</h2>
                <div class="insertForm">
	                <form id="insertForm">
						이름 &nbsp; &nbsp; &nbsp; <input type="text" name="admin_name" placeholder="이름" required><br>
<!-- 						<input type="password" name="admin_password" placeholder="비밀번호"><br> -->
						전화번호 <input type="tel" name="admin_phone" placeholder="전화번호" required><br>
						주소 &nbsp; &nbsp;  &nbsp; <input type="text" name="admin_addr" id="admin_addr" placeholder="주소" style="width : 500px;" required>
							<input type="button" onClick="goPopup()" class="btn1" value="주소검색" style="width : 150px;margin-left : 450px;">
						<br>
						근무지&nbsp;&nbsp;&nbsp; <select name="admin_store" required>
				        		<option value="">지점을 선택해 주세요.</option>
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
				        </select><br>
						입사일&nbsp;&nbsp;&nbsp;  <input type="date" name="admin_jday" required><br>
						직급&nbsp; &nbsp; &nbsp;&nbsp;  <select name="admin_dept" required>
							<option value="">직급을 선택하세요</option>
							<option value="1">총괄관리자</option>
							<option value="2">지점장</option>
							<option value="3">매니저</option>
							<option value="4">사원</option>
						</select>
						<input type="submit" value="사원계정생성" class="btn3"><br>
					</form>
				</div>
            </div>
            
            <div class="con3">
            	<h2>퇴사자관리</h2>
            	 <c:if test="${empty list }">
                	<h2>퇴사자 목록이 없습니다.</h2>
                </c:if>
                <c:if test="${not empty list }">

	                <div class="list-title cf">
	                	<span>사원번호</span>
	                	<span>지점</span>
	                	<span>직급</span>
	                	<span>사원명</span>
	                	<span>입사일</span>
	                	<span>퇴사일</span>
	                	<span>연락처</span>
	                	<span>주소</span>
	                </div>
	                <div class="list cf">
	                <c:forEach var="a" items="${list}"> 
					<c:if test="${a.deleted eq 'y'}"> 
					<p onclick="tab(4, ${a.admin_num})">
	                	<span>${a.admin_num}</span>
	                	<span>${a.admin_store}</span>
	                	<span>
							<c:choose>
								<c:when test="${a.admin_dept  == 1 }">
											총괄관리자
								</c:when>
								<c:when test="${a.admin_dept  == 2}">
											지점장
								</c:when>	
								<c:when test="${a.admin_dept == 3 }">
											매니저
								</c:when>	
								<c:when test="${a.admin_dept == 4 }">
											사원
								</c:when>		
							</c:choose>
						</span>
						<span>${a.admin_name}</span>
						<span>${a.admin_jday}</span>
						<span>${a.admin_lday}</span>
						<span>${a.admin_phone}</span>		
						<span>${a.admin_addr}</span>
						</p>	
					</c:if>
					</c:forEach>
					<!-- 
					<article>
						<c:if test="${paging.prev }">
						   	<a href="${cpath }/admin/admin_member?page=${paging.begin-1}">
						   	[이전]</a>
					   	</c:if>
						<c:forEach var="i" begin="${paging.begin }" end="${paging.end}">
							<span onclick="name(${i})">[${i}]</span>
						</c:forEach>
						<c:if test="${paging.next }">
						   	<a href="${cpath }/admin/admin_member?page=${paging.end+1}">
						   	[다음]</a>
					   	</c:if>
					</article>
					 -->
					</div>

				</c:if>
            </div>
            
            
            <div class="con4">							<!-- 사원 정보 수정 - 퇴사일 입력 가능 -->
                <h2>사원정보수정</h2>
                <div class="updateForm">
	                <form id="updateForm">
						
					</form>
				</div>
            </div>
            
        </div>

</section>


<script>
	document.getElementById('insertForm').onsubmit = function(e){
		e.preventDefault();
		const formData = new FormData(e.target);
		
		const url = '${cpath}/admin/admin_member/insert';
		const opt = {
				method:'POST',
				body:formData,
		}
		
		fetch(url, opt)
		.then(resp => resp.text())
		.then(text => {
			console.log(text)
			if(+text == 1){
				e.target.reset()
				alert('사원계정생성성공!!!!')
				location.reload()
			}else{
				alert('실패');
			}
		});
	}
	
	
	
	
	function name(data){
		location.href="${cpath }/admin/admin_member?page="+data
		
	}
</script>

<%@include file="../footer.jsp" %>

