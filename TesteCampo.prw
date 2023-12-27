#include "Protheus.CH"


/*/{Protheus.doc} User Function testecampo
)
    @type      @author user
    @since 22/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function testec()
    
DEFINE DIALOG oDlg TITLE "Vl. Desconto" FROM 180,180 TO 280,400 COLORS 0, 16777215 PIXEL 

// Local cTGet1 := ""
// Cria Fonte para visualização
 oFont := TFont():New('Times New Roman',,-18,.T.,.T.) 
 // Usando o método New
 oSay1:= TSay():New(01,03,{||'Vl. Desconto'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

nGet2:=0.00
  oGet2 := TGet():New( 014, 003, { | u | If( PCount() == 0, nGet2, nGet2 := u ) },oDlg, ;
     060, 010, "@E 999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nGet2",,,,.T.  )
oTButton1 := TButton():New( 28, 03, "Confirmar",oDlg,{||alert(CValToChar(nGet2)) }, 38,13,,,.F.,.T.,.F.,,.F.,,,.F. )
   
ACTIVATE DIALOG oDlg CENTERED
Return
