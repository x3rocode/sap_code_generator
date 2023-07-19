#Singleinstance Force
CoordMode, Mouse, Window

Gui, Add, GroupBox, r27 xm ym+10 w350 Section,TYPE
GUI, Add, Text, xs+10 ys+20, 이 친구는 이렇게 만들어줍니다 !
GUI, Add, Text, xs+10 y+10 w330 r5 vExText

GUI, Add, Text, xs+10 y+10, 테이블명
Gui, Add, Edit, xs+10 y+10 w170 vTblNmEdit
Gui, Add, Button, x+10  w100 gBtnOk, 확인

GUI, Add, Text, xs+10 y+10, 필드명
GUI, Add, Text, x+120, 주석
Gui, Add, Edit, r10 xs+10 y+10 vFldNmEdit 
Gui, Add, Edit, r10 x+10 vFldExpEdit

GUI, Add, Text, xs+10 y+20 , 결과
Gui, Add, Button, x+157  w100 gBtnCopy, 복사하기
Gui, Add, Edit, xs+10 y+10 w280 r10 vResultEdit

; ---------------------------------------------------

Gui, Add, GroupBox, r27 ym+10  w350 Section, Field Category
GUI, Add, Text, xs+10 ys+20, 이 친구는 이렇게 만들어줍니다 !
GUI, Add, Text, xs+10 y+10 w330 r5 vExText2

GUI, Add, Text, xs+10 y+55 , 출력 itab
Gui, Add, Button, x+134  w100 gBtnOk2, 확인
Gui, Add, Edit, xs+10 y+10 w280 r10 vItabEdit

GUI, Add, Text, xs+10 y+20 , 결과
Gui, Add, Button, x+157  w100 gBtnCopy2, 복사하기
Gui, Add, Edit, xs+10 y+10 w280 r10 vResultEdit2


Gui, Show, w735 h590, 코드를 만들어주는 친구

txt1 = 
(
-----------------------------------------------------
bukrs      TYPE ztrt2115-bukrs,         "Company Code
gjahr       TYPE ztrt2115-gjahr,          "Fiscal Year
chasu     TYPE ztrt2115-chasu,        "사내환 차수
-----------------------------------------------------
)

txt2 = 
(
-----------------------------------------------------
'BUKRS'       TEXT-f01  'X'  'ZTRT2115' 'BUKRS' ,
'GJAHR'       TEXT-f02  ' '  'ZTRT2115' 'GJAHR' ,
'CHASU'       TEXT-f03  ' '  'ZTRT2115' 'CHASU' ,
-----------------------------------------------------
)

guicontrol,  , ExText, %txt1%
guicontrol,  , ExText2, %txt2%

Return

BtnOk:
{
    Gui, Submit, NoHide
    StringSplit, FldList, FldNmEdit, "`r`n"
    StringSplit, ExpList, FldExpEdit, "`r`n"
    clipboard =  
    Loop, %FldList0%{
        StringLower, lFldList, FldList%A_Index%
        result := % result . lFldList . " TYPE " . TblNmEdit . "-" .  lFldList 
        result := % (FldList0 = A_Index) ? (result . "`.") : (result . "`,")
        x := 15 - Strlen(FldList%A_Index%)
        Loop, %x%{
            result := % result . " "
        }
        
        result := % result . """" . ExpList%A_Index%  . "`r`n"
    }
    
    guicontrol,  , ResultEdit, %result%
}



BtnOk2:
{
    Gui, Submit, NoHide
    clipboard =  
    str := RegExReplace(ItabEdit, "`n|`r", "뀨")
    itab := StrSplit(str, "뀨")
    result := "`t"
    n := 0
    
    Loop, % itab.MaxIndex(){
        ; 앞공백 제거
        ltrtxt := LTrim(itab[A_Index])
        
        ; 주석 제거
        len := InStr(ltrtxt, """")
        len > 0 ? (trtxt := Substr(ltrtxt, 1, len)) : (trtxt := ltrtxt)

        ; 변수명 추출
        RegExMatch(trtxt , "i)(.*\s)type", var)
        tvar := Trim(var1)
        StringUpper, varNm, tvar
        
        ; 없을경우 공백이거나 주석 : 한줄띔
        if (varNm = "") {
            n += 1
            result := % result . "`r`n`t"
            Continue
        }

        ; 테이블명 추출
        RegExMatch(trtxt , "i).[\s]+type[\s]+(.*)\-", tbl)
        tvar := Trim(tbl1)
        StringUpper, tblNm, tvar 

        ; 필드명 추출
        RegExMatch(trtxt , "\-(.*)\,", fld)
        tvar := Trim(fld1)
        StringUpper, fldNm, tvar 

        result := % result . "'" . varNm . "'"
        x := 15 - Strlen(varNm)
        Loop, % x{
            result := % result . " "
        }
        SetFormat, Float, 02.0
        idx := A_Index - n + 0.1
        result := % result . "TEXT-f" . idx . "   " 
        result := % (idx = 01) ? (result . "'X'") : (result . "' '")
        result := % result . "   '" . tblNm . "'  '" . fldNm . "'"
        result := % (itab.MaxIndex() = A_Index) ? (result . "`.`r`n") : (result . "`,`r`n`t")
        
    }

    guicontrol,  , ResultEdit2, %result%

}


BtnCopy:
{
    Gui, Submit, NoHide
    
    clipboard = %ResultEdit%
    return
}

BtnCopy2:
{
    Gui, Submit, NoHide
    
    clipboard = %ResultEdit2%
    return
}