<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <!-- DROPZONE -->
        <g:external dir="assets/plugins/dropzone" file="basic.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.css" />
        <g:external dir="assets/plugins/dropzone" file="dropzone.js" />
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Control de Juicios</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/juicio/search">Juicios</a>
                    </li>
                    <li class="active">
                        <strong>Registrar nuevo Asunto </strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuJuicios"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Alta de Juicio en Materia: ${materia?.nombre}</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${materia}">
                                <g:form class="form-horizontal" action="save" method="post" name="saveForm" id="saveForm">
                                    <g:if test="${materia.id != 4}">
                                        <fieldset>
                                            <g:if test="${flash.message}">
                                                <div class="alert alert-info alert-dismissable">
                                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                    ${flash.message}
                                                </div>
                                            </g:if>
                                            <g:hasErrors bean="${this.juicio}">
                                                <g:eachError bean="${this.juicio}" var="error">
                                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                                        <div class="alert alert-danger alert-dismissable">
                                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                                            <g:message error="${error}"/>
                                                        </div>
                                                    </g:if>
                                                </g:eachError>
                                            </g:hasErrors>
                                            <input type="hidden" name="materia" id="materia" value="${materia?.id}">
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Delegación * </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_ALTA_LABORAL_NACIONAL,ROLE_ALTA_CIVIL_NACIONAL,ROLE_ALTA_PENAL_NACIONAL'>  
                                                                <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'nombre')}" value="${juicio?.delegacion?.id}" optionKey="id" onchange = "${remoteFunction(controller : 'delegacion', action : 'getDatosDelegacionSeleccionada', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizarDelInfo(data)')}"/>
                                                            </sec:ifAnyGranted>
                                                            <sec:ifNotGranted roles='ROLE_ADMIN,ROLE_ALTA_LABORAL_NACIONAL,ROLE_ALTA_CIVIL_NACIONAL,ROLE_ALTA_PENAL_NACIONAL'>
                                                                <sec:ifAnyGranted roles='ROLE_ALTA_LABORAL,ROLE_ALTA_CIVIL,ROLE_ALTA_PENAL'>  
                                                                    <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${[usuario.delegacion]}" value="${juicio?.delegacion?.id}" optionKey="id" onchange = "${remoteFunction(controller : 'delegacion', action : 'getDatosDelegacionSeleccionada', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizarDelInfo(data)')}"/>
                                                                </sec:ifAnyGranted>
                                                            </sec:ifNotGranted>
                                                        </div>
                                                    </div>
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Expediente Interno * </label>
                                                    <div class="col-md-3">
                                                        <input id="expedienteInterno" required name="expedienteInterno" placeholder="AA-11-11111" style="text-transform: uppercase" data-mask="aa-99-99999" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expedienteInterno}">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Gerente Jurídico </label>
                                                    <div class="col-md-3">
                                                        <input id="gerenteJuridico" name="gerenteJuridico" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" />
                                                    </div>
                                                    <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Expediente de Juicio * </label>
                                                        <div class="col-md-3">
                                                            <input id="expediente" required name="expediente" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
                                                        </div>
                                                    </g:if>
                                                    <g:elseif test="${materia?.id == 3}">
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Notario</label>
                                                        <div class="col-md-3">
                                                            <input id="notario" required name="notario" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.notario}">
                                                        </div> 
                                                    </g:elseif>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Zona </label>
                                                    <div class="col-md-3">
                                                        <input id="zona" name="zona" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" />
                                                    </div>
                                                    <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Ambito * </label>
                                                    </g:if>
                                                    <g:elseif test="${materia?.id == 3}">
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Competencia * </label>
                                                    </g:elseif>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija el ambito...']" data-placeholder="Elija el ambito..." class="chosen-select" style="width:300px;" tabindex="2" name="ambito.id" id="ambito" from="${mx.gox.infonavit.sicj.catalogos.Ambito?.list(sort:'nombre')}" value="${juicio?.ambito?.id}" optionKey="id" onchange = "var materia = document.getElementById('materia').value; ${remoteFunction(controller : 'juicio', action : 'obtenerTiposDeProcedimiento', params : '\'ambito=\' + escape(this.value) + \'&materia=\' + materia', onSuccess : 'actualizar(data, \'tipoDeProcedimiento\');consultarMunicipios()')}" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Región </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <span class="input-group-addon btn btn-white btn-bitbucket" onClick="$('#modalAltaRegion').modal('show');"><i class="fa fa-plus"></i></span><g:select noSelection="['':'Elija la Región...']" data-placeholder="Elija la Región..." class="chosen-select" style="width:260px;" tabindex="2" name="region.id" id="region" from="${mx.gox.infonavit.sicj.admin.Region?.list(sort:'nombre')}" value="${juicio?.region}" optionKey="id" />    
                                                        </div>
                                                    </div>
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Tipo de Juicio * </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select class="chosen-select" id="tipoDeProcedimiento" name="tipoDeProcedimiento.id" data-placeholder="Elija primero el ambito..." style="width:300px;" tabindex="2" onchange = "consultarTipoDeParte(escape(this.value))">
                                                            </select>    
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                        <label class="col-md-2 control-label">Actores *</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group m-b" id='actorRemote'>
                                                                <div class="input-group-btn">
                                                                    <button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><i class="fa fa-gears"></i></button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a onclick="setTipoDeActor('actor'); $('#modalAltaPersona').modal('show');">Registrar Actor</a></li>
                                                                        <li><a onclick="$('#modalJuicioColectivo').modal('show');">Carga Masiva de Actores</a></li>
                                                                    </ul>
                                                                </div>
                                                                <input id="actor" style="width:295px;" name='actor' type="text" placeholder="Buscar actor..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                                            </div>
                                                            <input type="hidden" id="listaActoresLlena" name="listaActoresLlena" value="">
                                                            <div id="listaActores" class="input-group">
                                                            </div>
                                                        </div>
                                                    </g:if>
                                                    <g:elseif test="${materia?.id == 3}">    
                                                        <label class="col-md-2 control-label">Denunciante *</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group m-b" id='denuncianteRemote'>
                                                                <div class="input-group-btn">
                                                                    <button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><i class="fa fa-gears"></i></button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a onclick="setTipoDeActor('denunciante'); $('#modalAltaPersona').modal('show');">Registrar Denunciante</a></li>
                                                                    </ul>
                                                                </div>
                                                                <input id="denunciante" style="width:295px;" name='denunciante' type="text" placeholder="Buscar denunciante..." class=" form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                                            </div>
                                                            <input type="hidden" id="listaDenunciantesLlena" name="listaDenunciantesLlena" value="">
                                                            <div id="listaDenunciantes" class="input-group">
                                                            </div>
                                                        </div>
                                                    </g:elseif>
                                                    <label id="etiquetaTipoDeParte" class="col-md-2 col-lg-offset-1 control-label">Tipo de Parte * </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select class="chosen-select" id="tipoDeParte" name="tipoDeParte.id" data-placeholder="Elija primero el tipo de procedimiento..." style="width:300px;" tabindex="2">
                                                            </select>    
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                        <label class="col-md-2 control-label">Demandados *</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group m-b" id='demandadoRemote'>
                                                                <div class="input-group-btn">
                                                                    <button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><i class="fa fa-gears"></i></button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a onclick="setTipoDeActor('demandado'); $('#modalAltaPersona').modal('show');">Registrar Demandado</a></li>
                                                                    </ul>
                                                                </div>
                                                                <input id="demandado" style="width:295px;" name='demandado' type="text" placeholder="Buscar demandado..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                                            </div>
                                                            <input type="hidden" id="listaDemandadosLlena" name="listaDemandadosLlena" value="">
                                                            <div id="listaDemandados" class="input-group">
                                                            </div>
                                                        </div>
                                                    </g:if>
                                                    <g:elseif test="${materia?.id == 3}">
                                                        <label class="col-md-2 control-label">Probable Responsable *</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group m-b" id='responsableRemote'>
                                                                <div class="input-group-btn">
                                                                    <button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><i class="fa fa-gears"></i></button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a onclick="setTipoDeActor('probableResponsable'); $('#modalAltaPersona').modal('show');">Registrar Probable Resposanble</a></li>
                                                                    </ul>
                                                                </div>
                                                                <input id="probableResponsable" style="width:295px;" name='probableResponsable' type="text" placeholder="Buscar probable responsable..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                                            </div>
                                                            <input type="hidden" id="listaResponsablesLlena" name="listaResponsablesLlena" value="">
                                                            <div id="listaResponsables" class="input-group">
                                                            </div>
                                                        </div>
                                                    </g:elseif>
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Provisión * </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija la Provisión...']" data-placeholder="Elija la Provisión..." class="chosen-select" style="width:300px;" tabindex="2" name="provision.id" id="provision" from="${mx.gox.infonavit.sicj.catalogos.Provision?.list(sort: 'nombre')}" value="2" optionKey="id" />    
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <g:if test="${materia?.id == 1}">
                                                        <label class="col-md-2 control-label">Tercero Interesado</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group m-b" id='terceroRemote'>
                                                                <div class="input-group-btn">
                                                                    <button data-toggle="dropdown" class="btn btn-white dropdown-toggle" type="button"><i class="fa fa-gears"></i></button>
                                                                    <ul class="dropdown-menu">
                                                                        <li><a onclick="setTipoDeActor('terceroInteresado'); $('#modalAltaPersona').modal('show');">Registrar Tercero Interesado</a></li>
                                                                    </ul>
                                                                </div>
                                                                <input id="terceroInteresado" style="width:295px;" name='terceroInteresado' type="text" placeholder="Buscar tercero interesado..." class="form-control typeahead tt-input" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" autocomplete="off" >    
                                                            </div>
                                                            <input type="hidden" id="listaTercerosLlena" name="listaTercerosLlena" value="">
                                                            <div id="listaTerceros" class="input-group">
                                                            </div>
                                                        </div>
                                                    </g:if>
                                                    <g:if test="${materia?.id == 3}">
                                                        <label class="col-md-2 control-label"></label>
                                                        <div class="col-md-3">
                                                            <div class="checkbox checkbox-success checkbox-circle">
                                                                <input id="responsableZ" name="responsableZ" type="checkbox">
                                                                <label for="responsableZ">
                                                                    QUIEN RESULTE RESPONSABLE
                                                                </label>
                                                            </div>
                                                            <div class="error" id="errorResponsableZ"></div>
                                                        </div>
                                                    </g:if>
                                                    <g:if test="${materia?.id == 1 || materia?.id == 3}">    
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Fecha de Remisión al Despacho *</label>
                                                    </g:if>
                                                    <g:else>
                                                        <label class="col-md-2 col-lg-offset-6 control-label">Fecha de Remisión al Despacho *</label>
                                                    </g:else>
                                                    <div class="col-md-3">
                                                        <div class="form-group" id="data_1">
                                                            <div class="input-group date">
                                                                &nbsp;&nbsp;&nbsp;<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input required readOnly name="fechaRD" id="fechaRD" type="text" class="form-control">
                                                            </div>
                                                        </div>  
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Despacho *</label>
                                                    <div class="col-md-3">
                                                        <select class="chosen-select" id="despacho" name="despacho.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" onchange = "consultarDespacho(escape(this.value));" >
                                                        </select>     
                                                    </div>
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Número(s) de Crédito</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <input id="numeroDeCredito" name='numeroDeCredito' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/>    
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <div id="respDespachoDiv">
                                                        <label class="col-md-2 control-label">Responsable del Despacho </label>
                                                        <div class="col-md-3">
                                                            <input id="responsableDelDespacho" name='responsableDelDespacho' style="width:300px;" readonly type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/>  
                                                        </div>
                                                    </div>
                                                    <div id="respJuicioDiv" style="display:none;">
                                                        <label class="col-md-2 control-label">Responsable del Juicio *</label>
                                                        <div class="col-md-3">
                                                            <select class="chosen-select" id="responsableDelJuicio" name="responsableDelJuicio.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" >
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                        <label class="col-md-2 col-lg-offset-1 control-label">Prestaciones Reclamadas *</label>
                                                        <div class="col-md-3">
                                                            <div class="input-group">
                                                                <g:select noSelection="['':'Elija la Prestación Reclamada...']" data-placeholder="Elija la Prestación Reclamada..." class="chosen-select" style="width:300px;" tabindex="2" name="prestacionReclamada.id" id="prestacionReclamada" from="${mx.gox.infonavit.sicj.catalogos.PrestacionReclamada.findAll("from PrestacionReclamada pr where pr.materia.id = :idMateria and pr.id > 0 order by pr.nombre", [idMateria: materia.id])}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerTiposAsociados', params : '\'prestacionReclamada=\' + escape(this.value)', onSuccess : 'mostrarChecks(data,\'tiposAsociados\')')}"/>
                                                                </div>
                                                            </div>
                                                </g:if>
                                                <g:elseif test="${materia?.id == 3}">
                                                    <label class="col-md-2  col-lg-offset-1 control-label">Tipo de Asignación *</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <div class="row">
                                                                <g:select noSelection="['':'Elija el Tipo de Asignación...']" data-placeholder="Elija el Tipo de Asignación..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeAsignacion.id" id="tipoDeAsignacion" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAsignacion?.list(sort:'nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerDelitos', params : '\'tipoDeAsignacion=\' + escape(this.value)', onSuccess : 'mostrarChecks(data,\'delitos\')')}"/>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <br />
                                                            <input id="numeroDeAsignacion" name='numeroDeAsignacion' type="text" placeholder="Indique el numero de asignacion" size="150" class="form-control" maxlength="30" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/> 
                                                        </div>
                                                    </div>
                                                </g:elseif>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Lista de Usuarios </label>
                                                <div class="col-md-3">
                                                    <table style="width:300px;" id="usuariosDelDespacho" class="table table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th align="center">Nombre</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr><td>Seleccione el Despacho deseado para ver los usuarios que tendrán permitido visualizar el caso</td></tr>
                                                        </tbody>
                                                    </table>
                                                    <div id="hiddenUsuarios">
                                                    </div>
                                                </div>
                                                <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Tipos Asociados *</label>
                                                </g:if>
                                                <g:elseif test="${materia?.id == 3}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Delitos *</label>
                                                </g:elseif>
                                                <div class="col-md-3">
                                                    <div id="checkBoxes" class="input-group">
                                                    </div>
                                                    <div class="row" id="divCampoOtro" style="display: none;">
                                                        <br />
                                                        <input id="otro" name='otro' type="text" placeholder="Indique cual" size="150" class="form-control" maxlength="30" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <g:if test="${usuario.delegacion.id == 33}">
                                            <div id="radicacionDelJuicioDiv" class="form-group" style="display: none;">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">¿En dónde está radicado el juicio?</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="radicacionDelJuicio.id" id="radicacionDelJuicio" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'nombre')}" value="${juicio?.radicacionDelJuicio?.id}" optionKey="id" onchange = "consultarMunicipiosRadicacion();"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </g:if>
                                        <div class="form-group">
                                            <div class="row">
                                                <g:if test="${materia?.id == 1 || materia?.id == 2}"> 
                                                    <label class="col-md-2 control-label">Municipio *</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select class="chosen-select" id="municipioAutoridad" name="municipioAutoridad.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2" onchange = "consultarJuzgados(escape(this.value));" >
                                                            </select>    
                                                        </div>
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${materia?.id == 3}">
                                                    <label class="col-md-2 control-label">Municipio *</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <select class="chosen-select" id="municipioAutoridad" required name="municipioAutoridad.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2" onchange = "consultarAutoridades('municipio',escape(this.value));" >
                                                            </select>    
                                                        </div>
                                                    </div>
                                                </g:elseif>    
                                                <g:if test="${materia?.id == 1 || materia?.id == 3}"> 
                                                    <label class="col-md-2 col-lg-offset-1 control-label" style="display: none;">Antecedentes</label>
                                                </g:if>
                                                <g:else>
                                                    <label class="col-md-2 col-lg-offset-6 control-label" style="display: none;">Antecedentes</label>
                                                </g:else>
                                                <!--div class="col-md-3">
                                                    <textarea rows="4" cols="80" style="width: 300px;" id="antecedentes" name='antecedentes' placeholder="Escriba los antecedentes del caso" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase;"></textarea>   
                                                </div-->
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <g:if test="${materia?.id == 1 || materia?.id == 2}"> 
                                                    <label class="col-md-2 control-label">Juzgado *</label>
                                                    <div class="col-md-3">
                                                        <select class="chosen-select" id="juzgado" required name="juzgado.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" tabindex="2" onchange = "consultarAutoridades('juzgado',escape(this.value));">
                                                        </select> 
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${materia?.id == 3}">
                                                    <div id="divAutoridades">
                                                        <label class="col-md-2 control-label">Autoridad Ministerial Investigadora *</label>
                                                        <div class="col-md-10">
                                                            <select class="chosen-select" id="autoridad" required name="autoridad.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" tabindex="2">
                                                            </select> 
                                                        </div> 
                                                    </div>
                                                </g:elseif>
                                                <g:if test="${materia?.id == 1}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Patrocinador del Juicio * </label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija al Patrocinador...']" data-placeholder="Elija al Patrocinador..." class="chosen-select" style="width:300px;" tabindex="2" name="patrocinadoDelJuicio.id" id="patrocinadoDelJuicio" from="${mx.gox.infonavit.sicj.catalogos.PatrocinadorDelJuicio?.list(sort: 'nombre')}" value="${juicio?.patrocinadoDelJuicio}" optionKey="id" />
                                                        </div>
                                                    </div>
                                                </g:if>
                                            </div>
                                        </div>
                                        <g:if test="${materia?.id == 3}">
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Subprocuraduría</label>
                                                    <div class="col-md-3">
                                                        <input id="subprocuraduria" name="subprocuraduria" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.subprocuraduria}"> 
                                                    </div> 
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Unidad Especializada</label>
                                                    <div class="col-md-3">
                                                        <input id="unidadEspecializada" name="unidadEspecializada" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.unidadEspecializada}"> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Fiscalia</label>
                                                    <div class="col-md-3">
                                                        <input id="fiscalia" name="fiscalia" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.fiscalia}"> 
                                                    </div> 
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Mesa Investigadora</label>
                                                    <div class="col-md-3">
                                                        <input id="mesaInvestigadora" name="mesaInvestigadora" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.mesaInvestigadora}"> 
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row">
                                                    <label class="col-md-2 control-label">Agencia</label>
                                                    <div class="col-md-3">
                                                        <input id="agencia" name="agencia" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.agencia}"> 
                                                    </div>
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Otros</label>
                                                    <div class="col-md-3">
                                                        <input id="otraInstancia" name="otraInstancia" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.otraInstancia}"> 
                                                    </div>
                                                </div>
                                            </div>
                                        </g:if>
                                        <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                            <div class="form-group">
                                                <div id="divAutoridades" class="row">
                                                    <label class="col-md-2 control-label">Autoridad *</label>
                                                    <div class="col-md-10">
                                                        <select class="chosen-select" id="autoridad" required name="autoridad.id" data-placeholder="Elija primero el Juzgado..." style="width:300px;" tabindex="2">
                                                        </select> 
                                                    </div> 
                                                </div>
                                            </div>
                                        </g:if>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Ubicación del Inmueble</label>
                                                <div id="actionInmueble" class="col-md-1">
                                                    <a class="btn btn-white btn-bitbucket" onClick="mostrarDatosDeUbicacion();"><i class="fa fa-plus"></i></a>
                                                </div>
                                            </div>
                                            <div id="ubicacionForm">
                                                <div class="hr-line-dashed"></div>
                                                <div class="row">
                                                    <div class="row">
                                                        <label class="col-md-2 control-label">Calle </label>
                                                        <div class="col-md-3">
                                                            <input id="ubicacionCalle" name='ubicacionCalle' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" maxlength="100"/>    
                                                        </div>
                                                        <label class="col-md-2 control-label">Estado </label>
                                                        <div class="col-md-3">
                                                            <div class="input-group">
                                                                <g:select noSelection="['':'Elija el Estado...']" data-placeholder="Elija el Estado..." class="chosen-select" style="width:300px;" tabindex="2" name="ubicacionEstado.id" id="ubicacionEstado" from="${mx.gox.infonavit.sicj.catalogos.Estado?.list(sort:nombre)}" optionKey="id" onchange = "${remoteFunction(controller : 'autoridad', action : 'obtenerMunicipios', params : '\'estado=\' + escape(this.value)', onSuccess : 'actualizar(data,\'ubicacionMunicipio\')')}"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <br/>
                                                    <div class="row">
                                                        <label class="col-md-2 control-label">Número Exterior </label>
                                                        <div class="col-md-3">
                                                            <input id="ubicacionNumeroExterior" name='ubicacionNumeroExterior' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/>    
                                                        </div>
                                                        <label class="col-md-2  control-label">Municipio </label>
                                                        <div class="col-md-3">
                                                            <div class="input-group">
                                                                <select class="chosen-select" id="ubicacionMunicipio" name="ubicacionMunicipio.id" data-placeholder="Elija primero el Estado..." style="width:300px;" tabindex="2">
                                                                </select>    
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <br/>
                                                    <div class="row">
                                                        <label class="col-md-2 control-label">Número Interior </label>
                                                        <div class="col-md-3">
                                                            <input id="ubicacionNumeroInterior" name='ubicacionNumeroInterior' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/>    
                                                        </div>
                                                        <label class="col-md-2 control-label">Colonia </label>
                                                        <div class="col-md-3">
                                                            <input id="ubicacionColonia" name='ubicacionColonia' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/>    
                                                        </div>
                                                    </div>
                                                    <br/>
                                                    <div class="row">
                                                        <label class="col-md-2 control-label">Código Postal </label>
                                                        <div class="col-md-3">
                                                            <input id="ubicacionCP" name='ubicacionCP' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" maxlength="5"/>    
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="hr-line-dashed"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <g:if test="${materia?.id == 1 || materia?.id == 2}">
                                                    <label class="col-md-2 control-label">Cantidad Demandada</label>
                                                    <div class="col-md-4">
                                                        <div class="input-group">
                                                            <div class="row" style="margin-left: 5px;">
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="cantidadDemandada" id="cantidadDemandadaNo" value="NO" onclick="ocultarMonto();" checked="true">
                                                                    <label for="cantidadDemandadaNo">
                                                                        No Aplica
                                                                    </label>
                                                                </div>
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="cantidadDemandada" id="cantidadDemandadaSi" value="SI" onclick="mostrarMonto();">
                                                                    <label for="cantidadDemandadaSi">
                                                                        Si
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div id="divMonto" class="row">
                                                                <br />
                                                                <input id="monto" name='monto' type="text" placeholder="Indique el monto sin decimales" style="width: 300px;" class="form-control" maxlength="15" onKeyPress="return numbersonly(this, event)"/> 
                                                            </div>
                                                            <!--<div id="divMoneda" class="row">
                                                                <br />
                                                                <g:select noSelection="['':'Elija el Tipo de Moneda...']" data-placeholder="Elija el Tipo de Moneda..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeMoneda.id" id="tipoDeMoneda" from="${mx.gox.infonavit.sicj.catalogos.TipoDeMoneda?.list(sort:'nombre')}" optionKey="id" />
                                                            </div>-->
                                                        </div>
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${materia?.id == 3}">
                                                    <label class="col-md-2 control-label">Daño Patrimonial</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <div class="row" style="margin-left: 5px;">
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="danoPatrimonial" id="danoPatrimonialNo" value="NO" onclick="ocultarMonto();" checked="true">
                                                                    <label for="danoPatrimonialNo">
                                                                        No Aplica
                                                                    </label>
                                                                </div>
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="danoPatrimonial" id="danoPatrimonialSi" value="SI" onclick="mostrarMonto();">
                                                                    <label for="danoPatrimonialSi">
                                                                        Si
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div id="divMonto" class="row">
                                                                <br />
                                                                <input id="monto" name='monto' type="text" placeholder="Indique el monto sin decimales" style="width: 300px;" class="form-control" maxlength="15" onKeyPress="return numbersonly(this, event)"/> 
                                                            </div>
                                                            <!--<div id="divMoneda" class="row">
                                                                <br />
                                                                <g:select noSelection="['':'Elija el Tipo de Moneda...']" data-placeholder="Elija el Tipo de Moneda..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeMoneda.id" id="tipoDeMoneda" from="${mx.gox.infonavit.sicj.catalogos.TipoDeMoneda?.list(sort:'nombre')}" optionKey="id" />
                                                            </div>-->
                                                        </div>
                                                    </div>
                                                </g:elseif>
                                                <g:if test="${materia?.id == 1}">
                                                    <label class="col-md-2 control-label">¿Finado?</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <div class="row" style="margin-left: 5px;">
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="finado" id="finadoNo" value="NO" onclick="ocultarDatosFinado();" checked="true">
                                                                    <label for="finadoNo">
                                                                        No Aplica
                                                                    </label>
                                                                </div>
                                                                <div class="radio radio-success radio-inline">
                                                                    <input type="radio" name="finado" id="finadoSi" value="SI" onclick="mostrarDatosFinado();">
                                                                    <label for="finadoSi">
                                                                        Si
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div id="divNombreFinado" class="row">
                                                                <br />
                                                                <input id="nombreDelFinado" name='nombreDelFinado' type="text" placeholder="Escriba el nombre completo" style="width:300px;" size="150" class="form-control" maxlength="100"/> 
                                                            </div>
                                                            <div id="divNssFinado" class="row">
                                                                <br />
                                                                <input id="numeroSeguroSocialDelFinado" name='numeroSeguroSocialDelFinado' type="text" pattern="\d*" maxlength="11" placeholder="Escriba el Número de Seguridad Social" style="width:300px;" size="150" class="form-control" onKeyPress="return numbersonly(this, event)"/> 
                                                            </div>
                                                            <div id="divRfcFinado" class="row">
                                                                <br />
                                                                <input id="rfcDelFinado" name='rfcDelFinado' type="text" maxlength="13" placeholder="Escriba el RFC" style="width:300px;" size="150" class="form-control" /> 
                                                            </div>
                                                        </div>
                                                    </div>
                                                </g:if>
                                            </div>
                                        </div>
                                        <div class="hr-line-dashed"></div>
                                        <div class="form-group">
                                            <div class="col-sm-4 col-sm-offset-2">
                                                <button class="btn btn-white" type="button">Cancelar</button>
                                                <button class="btn btn-primary" type="submit">Guardar</button>
                                            </div>
                                        </div>
                                    </fieldset>
                                </g:if>
                            </g:form>
                            <div class="modal inmodal fade" id="modalAltaRegion" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                            <h4 class="modal-title">Registrar Nueva Región</h4>
                                            <small class="font-bold">Proporcione los siguientes datos para registrar la nueva Región.</small>
                                        </div>
                                        <div class="modal-body">
                                            <g:render template="/templates/altaRegion"/>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal inmodal fade" id="modalAltaPersona" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                            <h4 class="modal-title">Registrar Nueva Persona</h4>
                                            <small class="font-bold">Proporcione los siguientes datos para registrar la nueva Persona.</small>
                                        </div>
                                        <div class="modal-body">
                                            <g:render template="/templates/altaPersona"/>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" type="reset" onclick="limpiarFormularioPersona();" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal inmodal fade" id="modalJuicioColectivo" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                                            <h4 class="modal-title">Juicio Colectivo</h4>
                                            <small class="font-bold">Seleccione el archivo con el listado de actores del juicio (.csv,.xls).</small>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row text-center">
                                                <div class="col-lg-12">
                                                    <g:link class="btn btn-success btn-xs" action="descargarPlantilla"><i class="fa fa-file"></i>  Descargar Plantilla</g:link>
                                                    </div>
                                                </div>    
                                                <div class="row">
                                                    <div class="col-lg-12">
                                                        <div class="ibox float-e-margins">
                                                            <div class="ibox-title">
                                                                <h5>Área de Carga de Archivos</h5>
                                                            </div>
                                                            <div class="ibox-content">
                                                                <div class="row">
                                                                <g:render template="/templates/subirArchivos"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </g:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function guardarJuicio(){
        abrirSpinner();
        $.ajax({
        type:'POST',
        data:$('#saveForm').serialize(),
        url:'/sicj/juicio/save',
        success:function(data,textStatus){
        var resultado = eval(data);
        cerrarSpinner();
        if(resultado.exito === true){
            if(resultado.validacion){
              var html = "Se ha encontrado al finado en el siguiente Juicio:";
              html += "</br><div class='dropdown-messages-box'>";
              html += "<div class='media-body alert alert-danger'>";
              html += "<strong>" + resultado.validacion + "<strong><br>";
              html += resultado.mensaje + "<br>";
              html += "</div>";
              html += "</div>";
              sweetAlert({html: true,
                    title: "¡Atención!",
                    text: html,
                    type: "warning",
                    showCancelButton: false,
                    confirmButtonText: "Continuar",
                    closeOnConfirm: false
                }, function () {
                    window.location.href = resultado.url;
                });
            } else {
                window.location.href = resultado.url;
            }
        } else if(resultado.exito === false && resultado.errores){
            cerrarSpinner();
            sweetAlert("¡Cuidado!", "Hay campos que no han sido proporcionados, verifique e intente nuevamente.", "warning");
        } else if(resultado.exito === false && resultado.validacion){
            cerrarSpinner();
            var html = "Se ha encontrado otro juicio con el mismo expediente interno:";
            html += "</br><div class='dropdown-messages-box'>";
            html += "<div class='media-body alert alert-danger'>";
            html += "<strong>" + resultado.validacion + "<strong><br>";
            html += resultado.mensaje + "<br>";
            html += "</div>";
            html += "</div>";
            sweetAlert({html: true,
                title: "¡Atención!",
                text: html,
                type: "error",
                showCancelButton: false,
                closeOnConfirm: false
            });
        } else if(resultado.exito === false && resultado.actoresJuicio){
            cerrarSpinner();
            var html = "No se han registrado personas para el juicio:";
            html += "</br><div class='dropdown-messages-box'>";
            html += "<div class='media-body alert alert-danger'>";
            html += "<strong>" + resultado.mensaje + "</strong><br>";
            html += "</div>";
            html += "</div>";
            sweetAlert({html: true,
                title: "¡Atención!",
                text: html,
                type: "warning",
                showCancelButton: false,
                closeOnConfirm: false
            });
        }
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        cerrarSpinner();
        sweetAlert("Error", "Ocurrio un error al intentar enviar la petición. Intente nuevamente en unos minutos", "error");
        }
        });
        return false;
        }

        function cargarPlugins(){
        $('.i-checks').iCheck({
        radioClass: 'iradio_square-green'
        });
        $('.input-group.date').datepicker({
        todayBtn: "linked",
        keyboardNavigation: false,
        forceParse: false,
        format: 'dd/mm/yyyy',
        todayHighlight: true,
        calendarWeeks: true,
        daysOfWeekDisabled: [0,6],
        autoclose: true
        });
        var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
        elems.forEach(function(html) {
        var switchery = new Switchery(html);
        });
        var config = {
        '.chosen-select'           : {width:"300px"},
        '.chosen-select-deselect'  : {allow_single_deselect:true},
        '.chosen-select-no-single' : {disable_search_threshold:10},
        '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
        '.chosen-select-width'     : {width:"95%"}
        }
        for (var selector in config) {
        $(selector).chosen(config[selector]);
        }
        }

        function actualizarDelInfo(data) {
        var resultado = eval(data);
        $('#gerenteJuridico').val(resultado.gerenteJuridico);
        $('#zona').val(resultado.zona);
        $.ajax({
        type:'POST',
        data:'delegacion=' + $('#delegacion').val(), 
        url:'/sicj/despacho/obtenerDespachos',
        success:function(data,textStatus){
        actualizar(data, 'despacho');},
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        $.ajax({
        type:'POST',
        data:'delegacion=' + $('#delegacion').val(), 
        url:'/sicj/juicio/obtenerUsuariosDelegacion',
        success:function(data,textStatus){
        mostrarUsuariosDelegacion(data);},
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        consultarMunicipios();
        }

        function reiniciarAutoridades(materia){
            var htmlJ = "<option selected>Seleccione primero el Municipio...</option>";
        var htmlA = "";
        if(materia === "1" || materia === "2") {
            htmlA = "<option selected>Seleccione primero el Juzgado...</option>";
        } else if (materia === "3"){
            htmlA = "<option selected>Seleccione primero el Municipio...</option>";
        }
        $('#autoridad').html(htmlA);
        $('#autoridad .chosen-container').css('width', '300px');
        $('#juzgado').html(htmlJ);
        $('#juzgado').val('');
        $('#autoridad').val('');
        $('#autoridad').trigger("chosen:updated");
        $('#juzgado').trigger("chosen:updated");
        }

        function consultarMunicipios(){
        var delegacion = $('#delegacion').val()
        var materia = $('#materia').val();
        var ambito = $('#ambito').val();
        if(delegacion && materia && ambito){
        $.ajax({
        type:'POST',
        data:'estado=' + delegacion + "&materia=" + materia + "&ambito=" + ambito, 
        url:'/sicj/juicio/obtenerMunicipios',
        success:function(data,textStatus){
        actualizar(data,'municipioAutoridad');
        reiniciarAutoridades(materia);
        },error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        } else {
        console.log("No están seleccionados todos los campos necesarios");
        }
        }

        function consultarMunicipiosRadicacion(){
        var delegacion = $('#radicacionDelJuicio').val()
        var materia = $('#materia').val();
        var ambito = $('#ambito').val();
        if(delegacion && materia && ambito){
        $.ajax({
        type:'POST',
        data:'estado=' + delegacion + "&materia=" + materia + "&ambito=" + ambito, 
        url:'/sicj/juicio/obtenerMunicipios',
        success:function(data,textStatus){
        actualizar(data,'municipioAutoridad');
        reiniciarAutoridades(materia);
        },error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        } else {
        console.log("No están seleccionados todos los campos necesarios");
        }
        }

        function consultarJuzgados(municipio){
        var materia = $('#materia').val();
        var ambito = $('#ambito').val();
        $.ajax({
        type:'POST',
        data:'municipio=' + municipio + '&materia=' + materia + "&ambito=" + ambito,
        url:'/sicj/juicio/obtenerJuzgados',
        success:function(data,textStatus){
        actualizar(data,'juzgado');
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        }
        });
        }

        function consultarAutoridades(tipo,valor){
        var materia = $('#materia').val();
        var ambito = $('#ambito').val();
        var municipio
        var parametros = "";
        if(tipo === 'juzgado'){
        municipio = $('#municipioAutoridad').val();
        parametros = 'juzgado=' + valor + '&materia=' + materia + '&ambito=' + ambito + '&municipio=' + municipio;
        } else if (tipo === 'municipio'){
        municipio = valor;
        parametros = 'materia=' + materia + '&ambito=' + ambito + '&municipio=' + municipio;
        }
        $.ajax({
        type:'POST',
        data: parametros,
        url:'/sicj/juicio/obtenerAutoridades',
        success:function(data,textStatus){
        actualizar(data,'autoridad');
        redimensionarChosen('divAutoridades');
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        }
        });
        }

        function consultarDespacho(idDespacho){
            if(idDespacho > 0){
        $('#respJuicioDiv').hide();
        $('#respDespachoDiv').fadeIn();
        $.ajax({
        type:'POST',
        data:'despacho=' + idDespacho, 
        url:'/sicj/despacho/getDatosDespachoSeleccionado',
        success:function(data,textStatus){
        actualizarDespInfo(data);
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        } else {
        $('#respDespachoDiv').hide();
        $('#respJuicioDiv').fadeIn();
            $('#usuariosDelDespacho tbody').html("<tr><td>Seleccione el Despacho deseado para ver los usuarios que tendrán permitido visualizar el caso</td></tr>");
        }
        }

        function actualizarDespInfo(data) {
        var resultado = eval(data);
        $('#responsableDelDespacho').val(resultado.responsableDelDespacho);
        $.ajax({
        type:'POST',
        data:'despacho=' + $('#despacho').val(), 
        url:'/sicj/despacho/obtenerUsuariosActivosDelDespacho',
        success:function(data,textStatus){
        mostrarUsuariosDespacho(data);},
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }

        function mostrarUsuariosDespacho(data) {
        var resultado = eval(data);
        var html = "";
        var html2 = ""
        for (var x = 0; x < resultado.length; x++) {          
            html += "<tr><td>"+resultado[x].nombre+" " + resultado[x].apellidoPaterno + " "+resultado[x].apellidoMaterno+"</td></tr>";
            html2 += "<input type='hidden' name='udespacho_"+resultado[x].id+"' id='udespacho_"+resultado[x].id+"' value='"+resultado[x].id+"'>";
        }
        $('#usuariosDelDespacho tbody').html(html);
        $('#hiddenUsuarios').html(html2);
        }

        function mostrarUsuariosDelegacion(data) {
        var resultado = eval(data);
        var html = "";
            html += "<option value=''>Elija una opción...</option>";
        for (var x = 0; x < resultado.length; x++) {
            html += "<option value='"+resultado[x].id+"' >"+resultado[x].nombre+" " + resultado[x].apellidoPaterno + " "+resultado[x].apellidoMaterno+"</option>";
        }
        $('#responsableDelJuicio').html(html);
        $('#responsableDelJuicio').trigger("chosen:updated");
        }

        function mostrarDatosDeUbicacion(){
        $('#ubicacionForm').show('slow');
            $('#actionInmueble').html("<a class='btn btn-white btn-bitbucket' onClick='ocultarDatosDeUbicacion();'><i class='fa fa-minus'></i></a>");
        }

        function ocultarDatosDeUbicacion(){
        $('#ubicacionForm').hide('slow');
            $('#actionInmueble').html("<a class='btn btn-white btn-bitbucket' onClick='mostrarDatosDeUbicacion();'><i class='fa fa-plus'></i></a>");
        }

        function seleccionarNuevaRegion(data){
        var respuesta = eval(data);
        if(respuesta.id){
        obtenerRegiones(respuesta.id);
        } else {
        alert("Ocurrio un error al cargar la región");
        }
        }

        function obtenerRegiones(idNuevo){
        jQuery.ajax({
        type:'GET',
        url:'/sicj/region/obtenerRegiones',
        success:function(data,textStatus){
        actualizar(data, 'region');
        $('#region').val(idNuevo);
        $('#region').trigger("chosen:updated");
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }

        function consultarTipoDeParte(tipoDeProcedimiento){
        jQuery.ajax({
        type:'POST',
        data:'tipoDeProcedimiento=' + tipoDeProcedimiento,
        url:'/sicj/juicio/obtenerTiposDeParte',
        success:function(data,textStatus){
        var materia = $('#materia').val();
        actualizar(data, 'tipoDeParte');
        if(tipoDeProcedimiento === "2" && materia === "3"){
        $('#etiquetaTipoDeParte').html("Sujeto *");
        } else if(tipoDeProcedimiento === "4" && materia === "1"){
        $('#radicacionDelJuicioDiv').fadeIn();
        } else {
        $('#etiquetaTipoDeParte').html("Tipo de Parte *");
        }
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        }
        });
        }

        function actualizar(data, tipo) {
        var resultado = eval(data);
        var html = "";
            html += "<option value=''>Elija una opción...</option>";
        for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
        }
        $('#'+tipo).html(html);
        $('#'+tipo).trigger("chosen:updated");
        }

        function mostrarChecks(data, tipo) {
        var resultado = eval(data);
        var html = "";
        var valor;
        for (var x = 0; x < resultado.length; x++) {
            html += "<div class='row'>";
            html += "<div class='checkbox checkbox-primary checkbox-circle col-md-12'>";
        if(tipo == 'delitos'){
        html += "<input type='checkbox' id='DELITO_"+resultado[x].id+"' name='DELITO_"+resultado[x].id+"'";
        if(resultado[x].nombre === 'OTRO'){
        html += "onclick='gestionarCampoOtro();' "
        }
            html += "/>";
            html += "<label style='width: 300px;' for='DELITO_"+resultado[x].id + "'>"+resultado[x].nombre+"</label>";
        valor = resultado[x].tipoDeAsignacion.id
        actualizarPlaceholder(valor);
        } else if(tipo == 'tiposAsociados'){
        html += "<input type='checkbox' id='TASOCIADO_"+resultado[x].id+"' name='TASOCIADO_"+resultado[x].id+"'";
        if(resultado[x].nombre === 'OTRO'){
        html += "onclick='gestionarCampoOtro();' "
        }
            html += "/>";            
            html += "<label style='max-width:300px; width:300px;' for='TASOCIADO_"+resultado[x].id + "'>"+resultado[x].nombre+"</label>";
        }
            html += "</div>";
            html += "</div>";
        }
        $('#checkBoxes').html(html);
        }

        function ocultarModal(){
        $('#modalAltaRegion').modal('toggle');
        }

        function gestionarCampoOtro(){
        console.log($('#divCampoOtro').css('display'));
        if ( $('#divCampoOtro').css('display') === 'none' ){
        $('#divCampoOtro').show('slow');
        } else {
        $('#divCampoOtro').hide('slow');
        }
        }

        function ocultarModalPersona(){
        $('#modalAltaPersona').modal('toggle');
        }

        function setTipoDeActor(tipo){
        $('#tipoDeActor').val(tipo);
        }

        function limpiarFormularioPersona(){
        var frm = document.getElementsByName('modalPersonaForm')[0];
        frm.reset();
        $('#tipoDePersona').trigger("chosen:updated");
        $('#divNombrePersona').hide();
        $('#divAPPersona').hide();
        $('#divAMPersona').hide();
        $('#divRFCPersona').hide();
        $('#divNSSPersona').hide();
        $('#mensajesAltaPersona').html("");
        }
        
        function limpiarFormulario(){
        var frm = document.getElementsByName('modalPersonaForm')[0];
        frm.reset();
        $('#tipoDePersona').trigger("chosen:updated");
        $('#divNombrePersona').hide();
        $('#divAPPersona').hide();
        $('#divAMPersona').hide();
        $('#divRFCPersona').hide();
        $('#divNSSPersona').hide();
        $('#mensajesAltaPersona').html("");
        }

        function agregarNuevaPersona(data){
        var respuesta = eval(data);
        if(respuesta.persona){
        console.log("Si trae persona");
        var lista
        var tipoDeActor = $('#tipoDeActor').val()
        if(tipoDeActor == 'actor'){
        lista = "listaActores";
        } else if(tipoDeActor == 'demandado'){
        lista = "listaDemandados";
        }  else if(tipoDeActor == 'terceroInteresado'){
        lista = "listaTerceros";
        }  else if(tipoDeActor == 'denunciante'){
        lista = "listaDenunciantes";
        }  else if(tipoDeActor == 'probableResponsable'){
        lista = "listaResponsables";
        }
        agregaPersona(respuesta.persona,tipoDeActor,lista);
        } else {
        console.log("no trae persona");
        var html = "";
        if(respuesta.error){
            html += "<center><div class='alert alert-danger'>" + respuesta.error + "</div></center>";
        } else {
        for (var x = 0; x < respuesta.errors.length; x++) {
            html += "<center><div class='alert alert-danger'>" + respuesta.errors[x].message + "</div></center>";
        x++;
        }
        }
        $('#mensajesAltaPersona').html(html);
        }
        }

        function agregaPersona(persona,tipoDeActor,lista){
        var actor
        var tipo = typeof persona
        if(tipo == 'string'){
        actor = persona;
        } else {
        actor = eval(persona);
        actor =  actor.id;
        }
        if(actor){
        $.ajax({
        type:'POST',
        data:'persona=' + actor+'&tipoDeActor='+tipoDeActor, 
        url:'/sicj/juicio/agregarActor',
        success:function(data,textStatus){
        var respuesta = eval(data)
        var html = ""
        var html2 = "";
        var warnings = 0;
            html += "<div class='row' style='margin-left: -26%;'><div class='col-md-2'>";
            html += "<button class=\"btn btn-warning btn-xs\" type=\"button\" title=\"Eliminar Persona(s)\" onclick=\"quitaPersona('" + tipoDeActor + "','" + lista + "');\"><i class='fa fa-minus'></i></button>&nbsp;&nbsp;";
            html += "<button class=\"btn btn-danger btn-xs\" type=\"button\" title=\"Eliminar Todo\" onclick=\"eliminarTodo('" + tipoDeActor + "','" + lista + "');\"><i class='fa fa-trash'></i></button>";
            html += "</div><div class='col-md-10'>";
            html += "<select style='width:335px;font-size:12px;' class='form-control' id = '" + tipoDeActor + "Select' multiple>";
        for (var x = 0; x < respuesta.length; x++) {          
            html += "<option value='" + respuesta[x].persona.id + "'>" + "[" + respuesta[x].persona.id + "] - " + respuesta[x].persona.nombre;
        if(respuesta[x].persona.apellidoPaterno != 'null' && respuesta[x].persona.apellidoPaterno != null){
        html += " " + respuesta[x].persona.apellidoPaterno;
        }
        if(respuesta[x].persona.apellidoMaterno != 'null' && respuesta[x].persona.apellidoMaterno != null){
        html += " " + respuesta[x].persona.apellidoMaterno;
        }
            html += "</option>";          
        if(respuesta[x].tieneJuicio == 'true'){
        warnings++;
            html2 += "<li>";
            html2 += "<div class='dropdown-messages-box'>";
            html2 += "<div class='media-body alert alert-warning'>";
            html2 += "<strong> Se encontró a " + respuesta[x].persona.nombre + " " + respuesta[x].persona.apellidoPaterno + " " + respuesta[x].persona.apellidoMaterno + " en el siguiente juicio: </strong><br>" + respuesta[x].mensaje + ".<br>";
            html2 += "</div>";
            html2 += "</div>";
            html2 += "</li>";
            html2 += "<li class='divider'></li>";
        }
        }
            html += "</select></div></div>";
        $('#'+lista).html(html);
        $('#'+tipoDeActor).val('');
        $('#'+lista+"Llena").val(true);
        if(tipo == 'string'){
        limpiarFormulario();
        ocultarModalPersona();
        }
            if(warnings > 0){
        $('#cantidadWarnings').html(warnings);
        $('#listaWarnings').html(html2);
        mostrarAlertError("Se encontraron personas con juicios activos. Puede ver los detalles en el área de notificación ubicada en la esquina superior derecha.");
        }
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }
        }

        function quitaPersona(tipoDeActor,lista) {
        var actor = $('#'+tipoDeActor+'Select').val();
        if(actor){
        $.ajax({
        type:'POST',
        data:'persona=' + actor+'&tipoDeActor='+tipoDeActor, 
        url:'/sicj/juicio/quitarActor',
        success:function(data,textStatus){
        var respuesta = eval(data)
        var html = ""
        var html2 = "";
        var warnings = 0;
            if(respuesta.length > 0) {
            html += "<div class='row' style='margin-left: -26%;'><div class='col-md-2'>";
            html += "<button class=\"btn btn-warning btn-xs\" type=\"button\" title=\"Eliminar Persona(s)\" onclick=\"quitaPersona('" + tipoDeActor + "','" + lista + "');\"><i class='fa fa-minus'></i></button>&nbsp;&nbsp;";
            html += "<button class=\"btn btn-danger btn-xs\" type=\"button\" title=\"Eliminar Todo\" onclick=\"eliminarTodo('" + tipoDeActor + "','" + lista + "');\"><i class='fa fa-trash'></i></button>";
            html += "</div><div class='col-md-10'>";
            html += "<select style='width:335px;font-size:12px;' class='form-control' id = '" + tipoDeActor + "Select' multiple>";
        for (var x = 0; x < respuesta.length; x++) {          
            html += "<option value='" + respuesta[x].persona.id + "'>" + "[" + respuesta[x].persona.id + "] - " + respuesta[x].persona.nombre;
        if(respuesta[x].persona.apellidoPaterno != 'null' && respuesta[x].persona.apellidoPaterno != null){
        html += " " + respuesta[x].persona.apellidoPaterno;
        }
        if(respuesta[x].persona.apellidoMaterno != 'null' && respuesta[x].persona.apellidoMaterno != null){
        html += " " + respuesta[x].persona.apellidoMaterno;
        }
            html += "</option>";
        }
            html += "</select></div></div>";
        $('#'+lista).html(html);
        $('#'+tipoDeActor).val('');
        } else {
        $('#'+lista).html('');
        $('#'+tipoDeActor).val('');
        $('#'+lista+"Llena").val(false);
        }
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }
        }

        function eliminarTodo(tipoDeActor,lista) {
        $.ajax({
        type:'POST',
        data:'tipoDeActor='+tipoDeActor, 
        url:'/sicj/juicio/eliminarLista',
        success:function(data,textStatus){
        var respuesta = eval(data);
        if(respuesta.listaVacia){
        $('#'+lista).html('');
        $('#'+tipoDeActor).val('');
        $('#'+lista+"Llena").val(false);
        }
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
        });
        }

        function mostrarAlertError(mensaje){
        var materia = $('#materia').val();
        if((materia === "1" || materia === "2") || materia === "3"){
        swal({
        title: "¡Importante!",
        text: mensaje,
        type: "warning"
        });
        }
        }

        function redimensionarChosen(idDiv){
        $('#'+idDiv+" .chosen-container").css('width', '95%');
        //$('#'+idDiv+" .chosen-container").css('font-size', '11px');
        }

        function habilitarCamposPersona(valor){
        if($('#tipoDeActor').val() == 'actor' || $('#tipoDeActor').val() == 'denunciante' ){
        $('#divNombrePersona').show('slow');
        if(valor == 1){
        $('#divAPPersona').show('slow');
        $('#divAMPersona').show('slow');
        $('#divNSSPersona').show('slow');
        } else if (valor == 2){
        $('#divAPPersona').hide('slow');
        $('#divAMPersona').hide('slow');
        $('#divNSSPersona').hide('slow');
        }
        $('#divRFCPersona').show('slow');
        } else if($('#tipoDeActor').val() == 'demandado' || $('#tipoDeActor').val() == 'terceroInteresado' || $('#tipoDeActor').val() == 'probableResponsable' ){
        $('#divNombrePersona').show('slow');
        if(valor == 1){
        $('#divAPPersona').show('slow');
        $('#divAMPersona').show('slow');
        } else if (valor == 2){
        $('#divAPPersona').hide('slow');
        $('#divAMPersona').hide('slow');
        }
        $('#divRFCPersona').hide();
        $('#divNSSPersona').hide();
        } 
        }

        function mostrarMonto() {
        $('#divMonto').show('slow');
        } 

        function ocultarMonto() {
        $('#divMonto').hide('slow');
        }

        function mostrarDatosFinado() {
        $('#divNombreFinado').show('slow');
        $('#divNssFinado').show('slow');
        $('#divRfcFinado').show('slow');
        } 

        function ocultarDatosFinado() {
        $('#divNombreFinado').hide('slow');
        $('#divNssFinado').hide('slow');
        $('#divRfcFinado').hide('slow');
        }

        function actualizarPlaceholder(valor){
        if(valor === 1){
        $('#numeroDeAsignacion').attr("placeholder", "Número de Acta Especial");
        } else if (valor === 2){
        $('#numeroDeAsignacion').attr("placeholder", "Número de Averiguación Previa");
        } else if (valor === 3){
        $('#numeroDeAsignacion').attr("placeholder", "Número de Carpeta de Investigación");
        } else if (valor === 4){
        $('#numeroDeAsignacion').attr("placeholder", "Número de Noticia Criminal");
        }
        }
    </script>
    <script type="text/javascript">
        var limiteDeArchivos = 0;
        var archivosSubidos = 0;
        var progress = 0;
        var previewNode = document.querySelector("#template");
        previewNode.id = "";
        var previewTemplate = previewNode.parentNode.innerHTML;
        previewNode.parentNode.removeChild(previewNode);

        var myBodyDropzone = new Dropzone(document.body, {
        url: "/sicj/juicio/revisarArchivoActores",
        uploadMultiple: true,
        parallelUploads: 1,
        paramName: "archivo",
        maxFiles: 3,
        maxFilesize: 20,
        acceptedFiles: ".csv",
        previewTemplate: previewTemplate,
        autoQueue: false,
        previewsContainer: "#previews",
        clickable: ".fileinput-button"
        });

        myBodyDropzone.on("totaluploadprogress", function(progress) {
        //progress = null;
        console.log('- - - - % del progreso -> ' + progress);
        document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
        $('#total-progress .progress-bar').html("" + progress + " %");
        progress.value=0;
        });

        myBodyDropzone.on("uploadprogress", function(file) {
        console.log('% del progreso -> ' + file.upload.progress);
        progress = file.upload.progress;
        document.querySelector(".progress-bar-primary").style.width = progress + "%";
        $('.progress-bar-primary').html("" + progress + " %");
        progress = 0;
        });

        myBodyDropzone.on("successmultiple", function(files, response) {
        $('#modalJuicioColectivo').modal('toggle');
        var respuesta = eval(response)
        console.log(response)
        var html = ""
        var html2 = "";
        var html3 = "";
        var errores = 0;
        var warnings = 0;
            html += "<div class='row' style='margin-left: -26%;'><div class='col-md-2'>";
            html += "<button class=\"btn btn-warning btn-xs\" type=\"button\" title=\"Eliminar Persona(s)\" onclick=\"quitaPersona('actor','listaActores');\"><i class='fa fa-minus'></i></button>&nbsp;&nbsp;";
            html += "<button class=\"btn btn-danger btn-xs\" type=\"button\" title=\"Eliminar Todo\" onclick=\"eliminarTodo('actor','listaActores');\"><i class='fa fa-trash'></i></button>";
            html += "</div><div class='col-md-10'>";
            html += "<select style='width:335px;font-size:12px;' class='form-control' id = 'actorSelect' multiple>";
        for (var x = 0; x < respuesta.length; x++) {          
            if(respuesta[x].registrada === 'true' || respuesta[x].exito === 'true'){
                html += "<option value='" + respuesta[x].persona.id + "'>" + "[" + respuesta[x].persona.id + "] - " + respuesta[x].persona.nombre;
            if(respuesta[x].persona.apellidoPaterno != 'null' && respuesta[x].persona.apellidoPaterno != null){
            html += " " + respuesta[x].persona.apellidoPaterno;
            }
            if(respuesta[x].persona.apellidoMaterno != 'null' && respuesta[x].persona.apellidoMaterno != null){
            html += " " + respuesta[x].persona.apellidoMaterno;
            }
                html += "</option>";
            } else if(respuesta[x].registrada === 'false' || respuesta[x].nssVacio === 'true' || respuesta[x].nssYaRegistrado === 'true'){
            errores++;
                html3 += "<li>";
                html3 += "<div class='dropdown-messages-box'>";
                html3 += "<div class='media-body alert alert-danger'>";
                html3 += respuesta[x].mensaje + "<br>";
                html3 += "</div>";
                html3 += "</div>";
                html3 += "</li>";
                html3 += "<li class='divider'></li>";
            }
            if(respuesta[x].tieneJuicio == 'true'){
            warnings++;
                html2 += "<li>";
                html2 += "<div class='dropdown-messages-box'>";
                html2 += "<div class='media-body alert alert-warning'>";
                html2 += "<strong> Se encontró a " + respuesta[x].persona.nombre + " " + respuesta[x].persona.apellidoPaterno + " " + respuesta[x].persona.apellidoMaterno + " en el(los) siguiente(s) juicio(s): </strong><br><br>" + respuesta[x].mensaje + ".<br>";
                html2 += "</div>";
                html2 += "</div>";
                html2 += "</li>";
                html2 += "<li class='divider'></li>";
            }
        }
            html += "</select></div></div>";
        $('#listaActores').html(html);
        $('#actor').val('');
        $('#listaActoresLlena').val(false);
            if(warnings > 0){
        $('#cantidadWarnings').html(warnings);
        $('#listaWarnings').html(html2);
        mostrarAlertError("Se encontraron personas con juicios activos. Puede ver los detalles en el área de notificación ubicada en la esquina superior derecha.");
        }
            if(errores > 0){
        $('#cantidadErrores').html(errores);
        $('#listaErrores').html(html3);
        mostrarAlertError("Ocurrieron errores al analizar el archivo de actores, despliegue la lista en la esquina superior derecha para ver los detalles.");
        }
        document.querySelector("#total-progress .progress-bar").style.width = "0%";
        $('#total-progress .progress-bar').html("");
        document.querySelector(".progress-bar-primary").style.width = "0%";
        $('.progress-bar-primary').html("");
        console.log('antes de remover');
        myBodyDropzone.removeAllFiles(true);
        progress = 0;
        console.log('despues de remover');
        });

        myBodyDropzone.on("sending", function(file) {
        document.querySelector("#total-progress").style.opacity = "1";
        });

        document.querySelector("#actions .start").onclick = function() {
        myBodyDropzone.enqueueFiles(myBodyDropzone.getFilesWithStatus(Dropzone.ADDED)); 
        };

        function inicializarComponentes(){
        var bestPictures = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: '/sicj/juicio/buscarActores',
        remote: {
        url: '/sicj/juicio/buscarActores?query=%QUERY',
        wildcard: '%QUERY'
        }
        });
        $('#actorRemote .typeahead').typeahead({minLength: 3}, {
        name: 'actor',
        display: 'value',
        source: bestPictures,
        limit: 25,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al actor dando click en el botón de la izquierda.',
            '</div>'
        ].join('\n')
        }
        });
        $('#actorRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        agregaPersona(suggestion,'actor','listaActores');
        $('#actorRemote .typeahead').typeahead('val', "");
        });
        $('#demandadoRemote .typeahead').typeahead({minLength: 3}, {
        name: 'actor',
        display: 'value',
        source: bestPictures,
        limit: 25,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al demandado dando click en el botón de la izquierda.',
            '</div>'
        ].join('\n')
        }
        });
        $('#demandadoRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        agregaPersona(suggestion,'demandado','listaDemandados');
        $('#demandadoRemote .typeahead').typeahead('val', "");
        });
        $('#terceroRemote .typeahead').typeahead({minLength: 3}, {
        name: 'actor',
        display: 'value',
        source: bestPictures,
        limit: 25,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al tercero interesado dando click en el botón de la izquierda.',
            '</div>'
        ].join('\n')
        }
        });
        $('#terceroRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        agregaPersona(suggestion,'terceroInteresado','listaTerceros');
        $('#terceroRemote .typeahead').typeahead('val', "");
        });
        $('#denuncianteRemote .typeahead').typeahead({minLength: 3}, {
        name: 'actor',
        display: 'value',
        source: bestPictures,
        limit: 25,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al denunciante dando click en el botón de la izquierda.',
            '</div>'
        ].join('\n')
        }
        });
        $('#denuncianteRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        agregaPersona(suggestion,'denunciante','listaDenunciantes');
        $('#denuncianteRemote .typeahead').typeahead('val', "");
        });
        $('#responsableRemote .typeahead').typeahead({minLength: 3}, {
        name: 'actor',
        display: 'value',
        source: bestPictures,
        limit: 25,
        templates: {
        empty: [
            '<div class="empty-message">',
        'No existen coincidencias. Por favor registre al probable responsable dando click en el botón de la izquierda.',
            '</div>'
        ].join('\n')
        }
        });
        $('#responsableRemote .typeahead').bind('typeahead:select', function(ev, suggestion) {
        agregaPersona(suggestion,'probableResponsable','listaResponsables');
        $('#responsableRemote .typeahead').typeahead('val', "");
        });
        $('#numeroDeCredito').tagsinput({
        interactive:true,
        minChars:9,
        maxChars:10,
        width:'350px',
        delimiter: ',',
        unique:true,
        hide:true,
        removeWithBackspace:true,
        placeholderColor:'#666666',
        autosize: true,
        focus:false,
        });
        $('#numeroDeCredito').on('beforeItemAdd', function(event) {
        var tag =  event.item;
        var patt1 = /^[0-9]{10}$/;
        if(patt1.test(escape(tag))){
        event.cancel = false;
        } else {
        event.cancel = true;
        }
        });
        $('#ubicacionForm').hide();
        $('#divMonto').hide();
        $('#divMoneda').hide();
        $('#divNombreFinado').hide();
        $('#divNssFinado').hide();
        $('#divNombrePersona').hide();
        $('#divAPPersona').hide();
        $('#divAMPersona').hide();
        $('#divRFCPersona').hide();
        $('#divNSSPersona').hide();
        $('#divRfcFinado').hide();
        $('#autoridad').trigger("chosen:updated");
        $.validator.setDefaults({ ignore: ":hidden:not(.chosen-select, #listaActoresLlena, #listaDemandadosLlena, #listaDenunciantesLlena, #listaResponsablesLlena)" });
        $('[name="saveForm"]').validate({
        errorElement: 'div',
        ignore: ":hidden:not(.chosen-select, #listaActoresLlena, #listaDemandadosLlena, #listaDenunciantesLlena, #listaResponsablesLlena)",
        errorPlacement: function(error, element) {
        error.insertBefore(element);
        },
        rules: {
        "delegacion.id": "required",  
        "expedienteInterno": "required",
        "expediente": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "1" || materia === "2"){
        return true;
        } else {
        return false;
        }
        }
        },
        "ambito.id": "required",
        "tipoDeProcedimiento.id": "required",
        "tipoDeParte.id": "required",
        "provision.id": "required",
        "" : {
        },
        "listaActoresLlena" : {
        required : function(element){
        var materia = $('#materia').val();
        var listaAc = $('#listaActoresLlena').val();
        if((materia === "1" || materia === "2") && listaAc === ""){
        return true;
        } else {
        return false;
        }
        }
        },
        "listaDenunciantesLlena" : {
        required : function(element){
        var materia = $('#materia').val();
        var listaDe = $('#listaDenunciantesLlena').val();
        if(materia === "3" && listaDe === ""){
        return true;
        } else {
        return false;
        }
        }
        },
        "listaDemandadosLlena" : {
        required : function(element){
        var materia = $('#materia').val();
        var listaDe = $('#listaDemandadosLlena').val();
        if((materia === "1" || materia === "2") && listaDe === ""){
        return true;
        } else {
        return false;
        }
        }
        },
        "listaResponsablesLlena" : {
        required : function(element){
        var materia = $('#materia').val();
        var listaRe = $('#listaResponsablesLlena').val();
        if(materia === "3" && listaRe === "" && !($('[name="responsableZ"]').is(':checked'))){
        return true;
        } else {
        return false;
        }
        }
        },
        "responsableZ": {
        required : function(element){
        var materia = $('#materia').val();
        var listaPR = $('#listaResponsablesLlena').val();
        if(materia === "3" && listaPR === ""){
        return true;
        } else {
        return false;
        }
        }
        },
        "subprocuraduria": {
        required : function(element){
        var materia = $('#materia').val();
        var unidadEspecializada = $('#unidadEspecializada').val();
        var fiscalia = $('#fiscalia').val();
        var mesaInvestigadora = $('#mesaInvestigadora').val();
        var agencia = $('#agencia').val();
        if(materia === "3" && (!unidadEspecializada && !fiscalia && !mesaInvestigadora && !agencia)){
        return true;
        } else {
        return false;
        }
        }
        },
        "unidadEspecializada": {
        required : function(element){
        var materia = $('#materia').val();
        var subprocuraduria = $('#subprocuraduria').val();
        var fiscalia = $('#fiscalia').val();
        var mesaInvestigadora = $('#mesaInvestigadora').val();
        var agencia = $('#agencia').val();
        if(materia === "3" && (!subprocuraduria && !fiscalia && !mesaInvestigadora && !agencia)){
        return true;
        } else {
        return false;
        }
        }
        },
        "fiscalia": {
        required : function(element){
        var materia = $('#materia').val();
        var subprocuraduria = $('#subprocuraduria').val();
        var unidadEspecializada = $('#unidadEspecializada').val();
        var mesaInvestigadora = $('#mesaInvestigadora').val();
        var agencia = $('#agencia').val();
        if(materia === "3" && (!subprocuraduria && !unidadEspecializada && !mesaInvestigadora && !agencia)){
        return true;
        } else {
        return false;
        }
        }
        },
        "mesaInvestigadora": {
        required : function(element){
        var materia = $('#materia').val();
        var subprocuraduria = $('#subprocuraduria').val();
        var unidadEspecializada = $('#unidadEspecializada').val();
        var fiscalia = $('#fiscalia').val();
        var agencia = $('#agencia').val();
        if(materia === "3" && (!subprocuraduria && !unidadEspecializada && !fiscalia && !agencia)){
        return true;
        } else {
        return false;
        }
        }
        },
        "agencia": {
        required : function(element){
        var materia = $('#materia').val();
        var subprocuraduria = $('#subprocuraduria').val();
        var unidadEspecializada = $('#unidadEspecializada').val();
        var fiscalia = $('#fiscalia').val();
        var mesaInvestigadora = $('#mesaInvestigadora').val();
        if(materia === "3" && (!subprocuraduria && !unidadEspecializada && !fiscalia && !mesaInvestigadora)){
        return true;
        } else {
        return false;
        }
        }
        },
        "fechaRD": "required",
        "despacho.id": "required",
        "responsableDelJuicio.id": {
        required : function(element){
        var despacho = Number($('#despacho.id').val());
        if(despacho < 0){
        return true;
        } else {
        return false;
        }
        }
        },
        "prestacionReclamada.id": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "1" || materia === "2"){
        return true;
        } else {
        return false;
        }
        }
        },
        "tipoDeAsignacion.id": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "3"){
        return true;
        } else {
        return false;
        }
        }
        },
        "otro": {
        required : function(element){
        if ( $('#divCampoOtro').css('display') == 'none' ){
        return false;
        } else {
        return true;
        }
        }
        },
        "numeroDeAsignacion": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "3"){
        return true;
        } else {
        return false;
        }
        }
        },
        "municipioAutoridad.id": "required",
        "juzgado.id": "required",
        "autoridad.id": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "1" || materia === "2"){
        return true;
        } else {
        return false;
        }
        }
        },
        "patrocinadoDelJuicio.id": "required",
        "cantidadDemandada": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "1" || materia === "2"){
        return true;
        } else {
        return false;
        }
        }
        },
        "danoPatrimonial": {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "3"){
        return true;
        } else {
        return false;
        }
        }
        },
        monto: { 
        required: function(element){
        if(($('input[name="cantidadDemandada"]:checked').val() === 'SI') || ($('input[name="danoPatrimonial"]:checked').val() === 'SI')){
        return true;
        } else {
        return false;
        }
        },
        digits: true
        },
        finado: {
        required : function(element){
        var materia = $('#materia').val();
        if(materia === "1"){
        return true;
        } else {
        return false;
        }
        }
        },
        nombreDelFinado: {
        required: function(element){
        if(($('input[name="finado"]:checked').val() === 'SI')){
        return true;
        } else {
        return false;
        }
        }
        },
        numeroSeguroSocialDelFinado: {
        required: function(element){
        if(($('input[name="finado"]:checked').val() === 'SI')){
        return true;
        } else {
        return false;
        }
        },
        digits: true
        }
        },
        messages: {
        "delegacion.id": "Por favor indique la delegación",
        "expedienteInterno": "Por favor indique el expediente interno",
        "expediente": "Por favor indique el expediente",
        "ambito.id": "Por favor indique el ambito",
        "tipoDeProcedimiento.id": "Por favor indique el tipo de procedimiento",
        "tipoDeParte.id": "Por favor indique el tipo de parte",
        "provision.id": "Por favor indique la provision",
        "listaActoresLlena": "Por favor agregue al menos un actor",
        "listaDenunciantesLlena": "Por favor agregue al menos un denunciante",
        "listaDemandadosLlena": "Por favor agregue al menos un demandado",
        "listaResponsablesLlena": "Por favor agregue al menos un probable responsable",
        "responsableZ": "Por favor indique el probable responsable",
        "subprocuraduria": "Por favor indique la subprocuraduria",
        "unidadEspecializada": "Por favor indique la unidad especializada",
        "fiscalia": "Por favor indique la fiscalia",
        "mesaInvestigadora": "Por favor indique la mesa investigadora",
        "agencia": "Por favor indique la agencia",
        "fechaRD": "Por favor indique la fecha de remisión al despacho",
        "despacho.id": "Por favor indique el despacho",
        "responsableDeljuicio.id": "Por favor indique el responsable del juicio",
        "prestacionReclamada.id": "Por favor indique la prestación reclamada",
        "tipoDeAsignacion.id": "Por favor indique el tipo de asignación",
        "numeroDeAsignacion": "Por favor indique el número de asignación",
        "municipioAutoridad.id": "Por favor indique el municipio",
        "juzgado.id": "Por favor indique el juzgado",
        "autoridad.id": "Por favor indique la autoridad",
        "patrocinadoDelJuicio.id": "Por favor indique el patrocinadorDelJuicio",
        cantidadDemandada: "Por favor indique si aplica la cantidad demandada",
        danoPatromonial: "Por favor indique la cantidad pagada",
        monto: {
        required: "Por favor indique el monto",
        digits: "Por favor introduzca solo números enteros"
        }
        },
        submitHandler: function() {
        guardarJuicio();
        }
        });
        }

        $(document).ready(function(){
        inicializarComponentes();
        });
    </script>
    <style type="text/css">
        .typeahead, .tt-query, .tt-hint {
        border: 1px solid #CCCCCC;
        border-radius: 8px;
        line-height: 15px;
        outline: medium none;
        padding: 8px 12px;
        width: 300px;
        }
        .typeahead {
        background-color: #FFFFFF;
        }
        .typeahead:focus {
        border: 2px solid #0097CF;
        }
        .tt-query {
        box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
        }
        .tt-hint {
        color: #999999;
        }
        .tt-menu {
        background-color: #FFFFFF;
        border: 1px solid rgba(0, 0, 0, 0.2);
        border-radius: 8px;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        margin-top: 12px;
        padding: 8px 0;
        width: 300px;
        }
        .tt-suggestion {
        line-height: 24px;
        padding: 3px 20px;
        }
        .tt-suggestion.tt-is-under-cursor {
        background-color: #0097CF;
        color: #FFFFFF;
        }
        .tt-suggestion p {
        margin: 0;
        }
    </style>

</body>
</html>
