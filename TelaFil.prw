#INCLUDE 'Totvs.ch'

User Function KHRCS003()

Private cAlias := "ZZ1"
Private cCadastro := "Log de Integracao de Financeiros - Customer Success."

Private cDelFunc := ".T."
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                    {"Visualizar","AxVisual",0,2};
                    }

dbSelectArea(cAlias)
dbSetOrder(1)
dbSelectArea(cAlias)
mBrowse( 6,1,22,75,cAlias)


Return Nil
