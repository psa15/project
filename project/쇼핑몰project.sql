/*
작성자 : 박수아
편집일 : 2022-07-07
프로젝트명 : 쇼핑몰(개인)
07.07 - 참조키 설정
*/
--1. 회원테이블 (MEMBER)
CREATE TABLE TBL_MEMBER (
    M_ID                   VARCHAR2(15)                 CONSTRAINT PK_MEMBER PRIMARY KEY, -- 회원 id
    M_NAME              VARCHAR2(30)                NOT NULL, -- 회원 이름
    M_PASSWD           VARCHAR2(60)                 NOT NULL, --회원 비밀번호
    M_POSTNUM         CHAR(5)                           NOT NULL, --우편번호
    M_ADDR               VARCHAR2(100)                NOT NULL, --기본주소
    M_ADDR_D             VARCHAR2(100)              NOT NULL, --상세 주소
    M_TEL                    VARCHAR2(15)                   NOT NULL, --전화번호
    M_EMAIL                VARCHAR2(50)                 UNIQUE NOT NULL, --이메일
    M_EMAIL_ACCEPT    CHAR(1)                               NOT NULL, --이메일 수신 여부
    M_POINT                 NUMBER  DEFAULT 0           NOT NULL, --적립금
    M_REGDATE             DATE    DEFAULT SYSDATE    NOT NULL, --가입일
    M_UPDATEDATE       DATE    DEFAULT SYSDATE     NOT NULL, --수정일
    M_LASTDATE            DATE    DEFAULT SYSDATE    NOT NULL --최근 접속시간
);
--m_id, m_name, m_passwd, m_postnum, m_addr, m_addr_d, m_tel, m_email, m_email_accept, m_point, m_regdate, m_updatedate, m_lastdate

--2. 카테고리 테이블(CATEGORY)
CREATE TABLE TBL_CATEGORY(
    CT_CODE     NUMBER  CONSTRAINT PK_CATEGORY  PRIMARY KEY, --현재 카테고리코드
    CT_P_CODE   NUMBER, --부모 카테고리 코드
    CT_NAME     VARCHAR2(50)    NOT NULL --카테고리명
);
ALTER TABLE TBL_CATEGORY ADD CONSTRAINT FK_CT_P_CODE FOREIGN KEY(CT_P_CODE) REFERENCES TBL_CATEGORY(CT_CODE);
--ct_code, ct_p_code, ct_name

--3. 상품 테이블(PRODUCT)
CREATE TABLE TBL_PRODUCT(
    P_NUM               NUMBER                      CONSTRAINT PK_PRODUCT   PRIMARY KEY, --상품 번호
    F_CT_CODE           NUMBER,                                         --1차 카테고리 코드
    S_CT_CODE           NUMBER,                                          --2차 카테고리 코드
    P_NAME              VARCHAR2(50)                NOT NULL,    --상품명
    P_COST              NUMBER                          NOT NULL,     --상품가격
    P_DISCOUNT       NUMBER                          NOT NULL,    --상품의 할인율
    P_COMPANY       VARCHAR2(20)                  NOT NULL,     --상품 개발사
    P_DETAIL             CLOB                               NOT NULL,    --상품 상세정보
    P_IMAGE              VARCHAR2(50)                   NOT NULL, --상품 이미지
    P_AMOUNT          NUMBER                            NOT NULL, --상품 남은 수량
    P_BUY_OK             CHAR(1)                              NOT NULL,   --상품 구매 가능 여부
    P_REGDATE           DATE    DEFAULT SYSDATE     NOT NULL,   --상품 등록날짜
    P_UPDATEDATE      DATE    DEFAULT SYSDATE     NOT NULL,  --상품정보 수정날짜
    CONSTRAINT FK_P_CT_F_CODE FOREIGN KEY(F_CT_CODE) REFERENCES TBL_CATEGORY(CT_CODE),
    CONSTRAINT FK_P_CT_S_CODE FOREIGN KEY(S_CT_CODE) REFERENCES TBL_CATEGORY(CT_CODE)
);
--p_num, f_ct_code, s_ct_code, p_name, p_cost, p_discount, p_detail, p_image, p_amount, p_buy_ok, p_regdate, p_updatedate, p_company

--4. 장바구니(CART)
CREATE TABLE TBL_CART(
    CART_CODE              NUMBER             CONSTRAINT PK_CART  PRIMARY KEY, --장바구니 코드
    P_NUM                     NUMBER            NOT NULL,   --상품번호
    M_ID                        VARCHAR2(15)    NOT NULL,   --회원 ID 
    CART_AMOUNT           NUMBER            NOT NULL,    --구매수량
    CONSTRAINT FK_CART_P_NUM FOREIGN KEY(P_NUM) REFERENCES TBL_PRODUCT(P_NUM),
    CONSTRAINT FK_CART_M_ID FOREIGN KEY(M_ID) REFERENCES TBL_MEMBER(M_ID)
);
--cart_code, p_num, m_id, cart_amount

--5. 주문 테이블 (T_ORDER)
CREATE TABLE TBL_ORDER (
    ORD_CODE              NUMBER              CONSTRAINT  PK_T_ORDER    PRIMARY KEY, -- 주문번호
    M_ID                    VARCHAR2(15)       NOT NULL,   --회원 ID 
    ORD_NAME              VARCHAR2(30)        NOT NULL,   --받는 사람 이름
    ORD_POST               CHAR(5)                  NOT NULL,     --받는 사람 우편번호
    ORD_ADDR              VARCHAR2(100)       NOT NULL,       --받는 사람 기본주소
    ORD_ADDR_D            VARCHAR2(100)       NOT NULL,       --받는 사람 상세주소
    ORD_TEL                   VARCHAR2(15)                  NOT NULL,       --받는 사람 전화번호
    ORD_TOTALCOST         NUMBER                  NOT NULL,       --총 주문 금액
    ORD_DATE                  DATE    DEFAULT SYSDATE,                 --주문한 날짜
    CONSTRAINT FK_ORD_M_ID FOREIGN KEY(M_ID) REFERENCES TBL_MEMBER(M_ID)
);
--ord_code, m_id, ord_name, ord_post, ord_addr, ord_addr_d, ord_tel, ord_totalcost, ord_date

--6. 주문 상세 테이블(T_ORDER_D)
CREATE TABLE TBL_ORDER_D(
    ORD_CODE              NUMBER,                         --주문번호
    P_NUM               NUMBER,                             --상품번호
    ORD_AMOUNT        NUMBER          NOT NULL,   --주문수량
    ORD_COST              NUMBER          NOT NULL,   --주문 가격
    PRIMARY KEY(ORD_CODE, P_NUM),
    CONSTRAINT FK_ORD_P_NUM FOREIGN KEY(P_NUM) REFERENCES TBL_PRODUCT(P_NUM)
);
ALTER TABLE TBL_ORDER_D ADD CONSTRAINT FK_ORD_CODE FOREIGN KEY(ORD_CODE) REFERENCES TBL_ORDER(ORD_CODE);
--ord_code, p_num, ord_amount, ord_cost

--7. 게시판(BOARD)
CREATE TABLE TBL_BOARD(
	B_NUM				NUMBER							    CONSTRAINT PK_BOARD 	PRIMARY KEY,    --게시글 번호(시퀀스)
	M_ID					VARCHAR2(15)						NOT NULL,   --회원id(게시글 작성자)
	B_TITLE				VARCHAR2(100)						NOT NULL,   --게시글 제목
	B_CONTENT	    VARCHAR2(4000)					NOT NULL,   --게시글 내용
	B_REGDATE			DATE DEFAULT SYSDATE			NOT NULL,    --게시글 등록날짜
    CONSTRAINT FK_BOARD_M_ID FOREIGN KEY(M_ID) REFERENCES TBL_MEMBER(M_ID)
);
CREATE SEQUENCE SEQ_BOARD;
--b_num, m_id, b_title, b_content, b_regdate

--8. 리뷰
CREATE TABLE TBL_REVIEW(
	R_NUM				NUMBER							    CONSTRAINT PK_REVIEW 	PRIMARY KEY, --리뷰글 번호
	M_ID					VARCHAR2(15)						NOT NULL,   --회원 id
	P_NUM				NUMBER								NOT NULL,   --상품번호
	R_CONTENT		VARCHAR2(200)						NOT NULL,   --리뷰내용
	R_SCORE			NUMBER								NOT NULL,   --리뷰 평점
	R_REGDATE			DATE DEFAULT SYSDATE			NOT NULL,    --리뷰 작성일
    CONSTRAINT FK_REVIEW_M_ID FOREIGN KEY(M_ID) REFERENCES TBL_MEMBER(M_ID),
    CONSTRAINT FK_REVIEW_P_NUM FOREIGN KEY(P_NUM) REFERENCES TBL_PRODUCT(P_NUM)
);
--r_num, m_id, p_num, r_content, r_score, r_regdate

--9. 관리자 테이블 (ADMIN)
CREATE TABLE TBL_ADMIN(
	ADMIN_ID				VARCHAR2(15)					   CONSTRAINT PK_ADMIN 	PRIMARY KEY,    --관리자 id
	ADMIN_PW				VARCHAR2(60)						NOT NULL,   --관리자 비밀번호
	ADMIN_NAME			VARCHAR2(100)						NOT NULL,   --관리자명
	ADMIN_LASTDATE	DATE DEFAULT	SYSDATE		NOT NULL    --접속시간
);
--admin_id, admin_pw, admin_name, admin_lastdate