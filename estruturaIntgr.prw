#INCLUDE 'totvs.ch'

User function EstrutIntgr()

// Entender o conceito.
// L� a documentacao.
// Ver os campos obrigatorios no Server.
// Ver os pre-requisitos das demais entidade.
// V� os campos no Cliente.
// V� os requisitos de conex�o.


// Enviar Carga Inicial das entidades, do principal ao mais especificos -
// Enviar por Filial para todas as filiais.

// Enviar Carga Inicial. Devera capaz de executar por tela. // ou por Job.(Schedule)
    // Enviar as entidades pre-requisitadas.
    // Preparar, asinalar os registros da carga Inicial. do Principal entidade.
    // Listar e Enviar os registros asinalados.
    // Gravar Log de Retorno.

    // Criar uma tabela de log de retorno da entidade.
    // Criar condi��o para gravar o retorno de log da Entidade.
    // Criar tela para visualiza��o do Log. 

// Enviar atualiza��o por Schedule.
    // Identitificar os pontos de Manuten��o da Entidade Principal. Ponto em Fun��o padr�o, Customizado ou Webservices.
    // Asinalar registros quando havera manuten��o. executado por filial.
    // Listar os registros asinalados e enviar as requisi��es.
    // Gravar Log de Retorno.

Return










/*/{Protheus.doc} INICI0
    Envio em massa de cliente para a Neocredit para atualiza��o de dados de cr�dito
    @type function
    @version 1.0
    @author Daniel Scheeren - Gruppe
    @since 28/10/2022
    @return variant, return_description
    /*/
User Function INICI()

    Local lRet       := .T.
    Local aArea      := FWGetArea()
    Local aPergs     := {}
    Local oWindow, oPanelWnd, oFWLayerMain, oPanel, oGetGrid
    // busca os clientes com limite vencido 
    Local lLimitVenc := .T.
    // data ultima compra at�
    Local dDataUltCo := FirstDate(Date())
    // Local cQuery    := ""
    Private cAliasTmp := GetNextAlias()
    Private aHeader   := {}
    Private aStruct   := {}
    Private cMark     := GetMark()

    If( Select(cAliasTmp) != 0, (cAliasTmp)->(DbCloseArea()), )

    // tipo
    //  1= caracter, data, numerico
    //  2= combobox
    //  4= checkbox
    //  6= diret�rio
    //            tipo, pergunta,                              valor inicial, picture, valida��o,          F3, edit�vel,   tamanho
    aadd(aPergs, {4,    "Somente com limite vencido ?"     ,   lLimitVenc,    ""  ,                                        80 ,    .F., .F.})
    aadd(aPergs, {1,    "Dt da ultima compra a partir de ?",   dDataUltCo,    "@D",    "!Empty(MV_PAR02)", "", ".T.",      80 ,    .F.})

    If Parambox(aPergs, "Informe os par�metros de filtro:", ,,,.F.)//,300,3, )

        MontaDados()

        // tela principal
        oWindow := FWDialogModal():New()
        oWindow:SetBackground(.T.)
        oWindow:SetTitle(oMainWnd:cTitle)
        oWindow:EnableAllClient()
        oWindow:EnableFormBar(.T.)
        oWindow:SetCloseButton(.F.)
        oWindow:SetEscClose(.F.)

        // seta a largura e altura da janela em pixel
        oWindow:SetSize(300, 650)
    
        oWindow:CreateDialog()

        oWindow:AddCloseButton({|| oGetGrid:DeActivate(), oWindow:DeActivate() }, "Confirmar")
        oWindow:AddButtons({{, "Cancelar", {|| lRet := .F., oGetGrid:DeActivate(), oWindow:DeActivate() }, "Cancelar", , .T., .F.}})
    
        oPanelWnd := oWindow:GetPanelMain()

        // ----- cria o conteiner principal onde ser�o apresentados os browses -----
        oFWLayerMain := FWLayer():New()
        oFWLayerMain:Init(oPanelWnd, .F.)
        oFWLayerMain:AddCollumn( 'ALL', 80, .T., 'UP' )
        oPanel := oFWLayerMain:GetColPanel( 'ALL', 'UP' )

        // cria grid de sele��o dos clientes para envio
        oGetGrid := FWMarkBrowse():New()
        oGetGrid:SetOwner(oPanel)
        oGetGrid:SetIgnoreARotina(.T.)
        oGetGrid:SetMenuDef("")
        oGetGrid:DisableFilter()
        oGetGrid:DisableConfig()
        oGetGrid:DisableReport()
        oGetGrid:DisableSeek()
        oGetGrid:DisableSaveConfig()
        oGetGrid:DisableDetails()
        oGetGrid:SetAlias(cAliasTmp)
        oGetGrid:SetTemporary(.T.)
        // oGetGrid:SetFields(aHeader)
        oGetGrid:SetColumns(aStruct)

        // indica o Code-Block executado no clique do registro
        // oGetGrid:bMark := { || Mark(oGetGrid:Mark()), oGetGrid:Refresh(.T.)  }
        // indica o Code-Block executado no clique do header da coluna de marca/desmarca
        oGetGrid:bAllMark := { || InvertMark(oGetGrid:Mark()), oGetGrid:Refresh(.T.)  }

        
        // define o campo que sera utilizado para a marca��o
        oGetGrid:SetMark(cMark, cAliasTmp, "OK")
        oGetGrid:SetFieldMark('OK')

        // ativa o browse
        oGetGrid:Activate()
        // ativa dialog
        oWindow:Activate()

        If lRet
            Processa({|| EnviaClientes() }, "Processando...", "Aguarde")

            FwAlertSuccess("Processo finalizado!")
        EndIf

    EndIf   
    
    If( Select(cAliasTmp) != 0, (cAliasTmp)->(DbCloseArea()), )

    FWRestArea(aArea)
    
Return Nil



// /*/{Protheus.doc} User Function 
//     (long_description)
//     @type  Function
//     @author user
//     @since 26/12/2023
//     @version version
//     @param param_name, param_type, param_descr
//     @return return_var, return_type, return_description
//     @example
//     (examples)
//     @see (links_or_references)
//     /*/
// User Function IniCi()
    
// Local aEmp := {{"01",{"01","02","03","04","05"}},{"02",{"01"}},{"03",{"01"}},{"04",{"01","02","03","04","05","06","07","08"}}}
// Local n,m
// aAreaOld := GetArea()
// Local _cAlias := GetNextAlias()
// Local i := 0
// Local cQuery := ''
// Local  _aRet01  := {}
// Local lRet := .T.
// Local nQuant := 0


// cQuery += "Select * from SYS_COMPANY order by M0_CODIGO, M0_CODFIL" //M0_CODIGO;  M0_NOME; M0_CODFIL; M0_FILIAL

// dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),_cAlias,.T.,.T.)

// (_cAlias)->(dbgotop())

// Count to nQuant
// ProcRegua(nQuant)
// (_cAlias)->(dbGoTop())

// if  nQuant > 0 

//     While (_cAlias)->(!EOF())
//         i++
//         (_cAlias)->(M0_CODIGO)
//         (_cAlias)->(M0_NOME)
//         (_cAlias)->(M0_CODFIL)
//         (_cAlias)->(M0_FILIAL)
//     ENDDo

// Else
//     lRet := .F.
// EndIf



// for  n := 1 to Len(aEmp)
    
//     _cEmp := aEmp[n,1]
//     for m := 1 to Len(aEmp[n,2])
//         _cFil := aEmp[n,2,m]
//         StartJob("U_ExecporFil", GetEnvServer(), .T., {_cEmp, _cFil})
//     next

// next

// RestArea(aAreaOld)

// Return


/*/{Protheus.doc} MontaDados
Monta dados da tabela para sele��o
    @type function
    @version 1.0
    @author Daniel Scheeren - Gruppe
    @since 18/11/2022
    @return variant, return_description
    /*/
Static Function MontaDados()

    // cria tabela tempor�ria
    Local oTempTable := FWTemporaryTable():New(cAliasTmp)
    Local cAliasSA1  := GetNextAlias()
    Local aFields := {}
    Local i, oColumn
    Local cQuery := ""

    If( Select(cAliasSA1) != 0, (cAliasSA1)->(DbCloseArea()), )

    // adiciona no array das colunas as que ser�o incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
    aadd(aFields, {"OK",         "C", 2,                      0})
    aadd(aFields, {"M0_CODIGO",  "C", 4, 0})
    aadd(aFields, {"M0_NOME",    "C", 30,    0})
    aadd(aFields, {"M0_CODFIL",  "C", 4,   0})
    aadd(aFields, {"M0_FILIAL",  "C", 30,   0})
    
    // define as colunas usadas, adiciona indice e cria a temporaria no banco
    oTempTable:SetFields( aFields )
    oTempTable:AddIndex("1", {"M0_CODIGO", "M0_CODFIL" })
    oTempTable:Create()

    // cabe�alho
    DbSelectArea("SX3")
    SX3->(DbSetOrder(2))    // 2- X3_CAMPO
    
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - M�scara
 

    aadd(aHeader, {"Cod. Empresa", aFields[2, 1], aFields[2, 2], aFields[2, 3], aFields[2, 4], "@!"})
    aadd(aHeader, {"Nome Empresa", aFields[3, 1], aFields[3, 2], aFields[3, 3], aFields[3, 4], "@!"})
    aadd(aHeader, {"Cod. Filial" , aFields[4, 1], aFields[4, 2], aFields[4, 3], aFields[4, 4], "@!"})
    aadd(aHeader, {"Nome Filial" , aFields[5, 1], aFields[5, 2], aFields[5, 3], aFields[5, 4], "@!"})

 
    // cria as colunas
    For i := 1 To Len(aHeader)
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| " + cAliasTmp + "->" + aHeader[i, 2] +"}"))
        oColumn:SetTitle(aHeader[i, 1])
        oColumn:SetType(aHeader[i, 3])
        oColumn:SetSize(aHeader[i, 4])
        oColumn:SetDecimal(aHeader[i, 5])
        oColumn:SetPicture(aHeader[i, 6])
        aadd(aStruct, oColumn)
    Next

    // // tabela tempor�ria para apresenta��o de dados na grid
    // cQuery := " SELECT * "
    // cQuery += " FROM " + RetSQlTab("SA1")
    // cQuery += " WHERE SA1.D_E_L_E_T_ = '' "
    // cQuery += " AND SA1.A1_FILIAL = '" + FWxFilial("SA1") + "' "

    // // filtra limite de cr�dito vencido
    // If MV_PAR01
    //     cQuery += " AND A1_VENCLC < '" + DToS(Date()) + "' "
    // EndIf
    // // filtra data da ultima compra
    // cQuery += " AND A1_ULTCOM >= '" + DToS(MV_PAR02) + "' "
    // cQuery += " ORDER BY A1_FILIAL, A1_COD, A1_LOJA "

    cQuery += "Select * from SYS_COMPANY order by M0_CODIGO, M0_CODFIL"

    DbUseArea(.T., "TOPCONN", TCGenQry(, , cQuery), (cAliasSA1), .F., .T.)
    DbSelectArea(cAliasSA1)
    (cAliasSA1)->(DbGoTop())

    While ! (cAliasSA1)->(Eof())
        RecLock(cAliasTmp, .T.)
        (cAliasTmp)->OK         := cMark
        (cAliasTmp)->M0_CODIGO  := (cAliasSA1)->M0_CODIGO
        (cAliasTmp)->M0_NOME    := (cAliasSA1)->M0_NOME
        (cAliasTmp)->M0_CODFIL  := (cAliasSA1)->M0_CODFIL
        (cAliasTmp)->M0_FILIAL  := (cAliasSA1)->M0_FILIAL
        MsUnlock()

        (cAliasSA1)->(DbSkip())
    End

    If( Select(cAliasSA1) != 0, (cAliasSA1)->(DbCloseArea()), )

Return


/*/{Protheus.doc} InvertMark
    Inverte marca��o ao clicar no header
    @type function
    @version 1.0
    @author Daniel Scheeren - Gruppe
    @since 19/11/2022
    @param cMark, character, Marca do campo
    @return variant, return_description
    /*/
Static Function InvertMark(cMark)
    
    (cAliasTmp)->(DbGoTop())

    While !(cAliasTmp)->(Eof())

        RecLock(cAliasTmp, .F.)
            (cAliasTmp)->OK := If(Empty((cAliasTmp)->OK), cMark, "  ")
        (cAliasTmp)->(MsUnlock())

        (cAliasTmp)->(DbSkip())
    End

Return Nil


/*/{Protheus.doc} User Function 
    (long_description)
    @type  Function
    @author user
    @since 26/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ExecporFil(aFil)

cCodEmp := aFil[1]
cCodFil := aFil[2]

	RpcSetType(3)
	RpcSetEnv(cCodEmp, cCodFil)

    Processa( {|| ICSSegto() }, "Processando..., Emp:"+cCodEmp+", Filial:"+cCodFil+"... ", " ",.T.)

    // Processa( {|| (U_ICSSegto() , U_ICSTpCnt(), U_PopularZSC(), U_ICSClient(), U_InMrcCtr(), U_ICSContr(), U_InMrcCnt(), U_ICSContact(),  U_ICSFinanc()) }, "Processando..., Emp:"+cEmpAnt+", Filial:"+cFilAnt+"... ", " ",.T.)

    RpcClearEnv()

Return


/*/{Protheus.doc} ICSSegto
    (long_description)
    @type  Static Function
    @author user
    @since 26/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ICSSegto()

// ChkFile("ZZ1")

// DBSelectArea("ZZ1")
// ZZ1->(DbSetOrder(1))

// Reclock("ZZ1",.T.)
// ZZ1->ZZ1_FILIAL := FwFilial()
// ZZ1->ZZ1_COD    := "000002"
// MsUnlock()

cFilTeste   := FwFilial()
cFilName    := FwFilialName()
cTabSA1     := RetSqlName("SA1")
ConOut(cFilTeste + " " + cTabSA1)

Return
