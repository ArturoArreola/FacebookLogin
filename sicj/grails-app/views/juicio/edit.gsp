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
                        <strong>Editar Asunto </strong>
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
                            <h5>Editar Juicio: ${juicio?.expedienteInterno}</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${juicio}">
                                <form class="form-horizontal" action="/sicj/juicio/update" method="post">
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
                                        <input type="hidden" name="materia" id="materiaJuicio" value="${juicio?.materia}">
                                        <input type="hidden" name="id" value="${juicio.id}" />
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Delegación </label>
                                                <div class="col-md-3">
                                                    <input id="gerenteJuridico" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" value="${juicio.delegacion}" />
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
                                                    <input id="gerenteJuridico" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" value="${gerenteJuridico}"/>
                                                </div>
                                                <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Expediente de Juicio * </label>
                                                    <div class="col-md-3">
                                                        <input id="expediente" required name="expediente" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${juicio.materia?.id == 3}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Notario </label>
                                                    <div class="col-md-3">
                                                        <input id="notario" name="notario" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.notario}">
                                                    </div>
                                                </g:elseif>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Zona </label>
                                                <div class="col-md-3">
                                                    <input id="zona" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" value="${juicio.delegacion.division}"/>
                                                </div>
                                                <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Ambito * </label>
                                                </g:if>
                                                <g:elseif test="${juicio.materia?.id == 3}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Competencia * </label>
                                                </g:elseif>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <input id="ambito" style="width:270px;" readOnly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.ambito}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Región </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <span class="input-group-addon btn btn-white btn-bitbucket" onClick="$('#modalAltaRegion').modal('show');"><i class="fa fa-plus"></i></span><g:select noSelection="['':'Elija la Región...']" data-placeholder="Elija la Región..." class="chosen-select" style="width:260px;" tabindex="2" name="region.id" id="region" from="${mx.gox.infonavit.sicj.admin.Region?.list(sort:'nombre')}" value="${juicio?.region?.id}" optionKey="id" />    
                                                    </div>
                                                </div>
                                                <label class="col-md-2 col-lg-offset-1 control-label">Tipo de Juicio * </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <input id="tipoDeProcedimiento" style="width:270px;" readOnly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.tipoDeProcedimiento}">   
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                    <label class="col-md-2 control-label">Actores</label>
                                                    <div class="col-md-3">
                                                        <div id="listaActores" class="input-group">
                                                            <select style='width:335px;font-size:12px;' class='form-control' readOnly multiple>
                                                                <g:each var='actor' in='${actores}'>
                                                                    <g:if test="${actor.tipoDeParte.id == 5}">
                                                                        <option>${actor.persona}</option>
                                                                    </g:if>
                                                                </g:each>
                                                            </select>    
                                                        </div>
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${juicio.materia?.id == 3}">    
                                                    <label class="col-md-2 control-label">Denunciante</label>
                                                    <div class="col-md-3">
                                                        <div id="listaDenunciantes" class="input-group">
                                                            <select style='width:335px;font-size:12px;' class='form-control' readOnly multiple>
                                                                <g:each var='actor' in='${actores}'>
                                                                    <g:if test="${actor.tipoDeParte.id == 6}">
                                                                        <option>${actor.persona}</option>
                                                                    </g:if>
                                                                </g:each>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </g:elseif>
                                                <label class="col-md-2 col-lg-offset-1 control-label">Tipo de Parte * </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <input id="tipoDeParte" style="width:270px;" readOnly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.tipoDeParte}">       
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                    <label class="col-md-2 control-label">Demandados</label>
                                                    <div class="col-md-3">
                                                        <div id="listaDemandados" class="input-group">
                                                            <select style='width:335px;font-size:12px;' class='form-control' readOnly multiple>
                                                                <g:each var='actor' in='${actores}'>
                                                                    <g:if test="${actor.tipoDeParte.id == 2}">
                                                                        <option>${actor.persona}</option>
                                                                    </g:if>
                                                                </g:each>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </g:if>
                                                <g:elseif test="${juicio.materia?.id == 3}">
                                                    <label class="col-md-2 control-label">Probable Responsable</label>
                                                    <div class="col-md-3">
                                                        <div id="listaResponsables" class="input-group">
                                                            <select style='width:335px;font-size:12px;' class='form-control' readOnly multiple>
                                                                <g:each var='actor' in='${actores}'>
                                                                    <g:if test="${actor.tipoDeParte.id == 7}">
                                                                        <option>${actor.persona}</option>
                                                                    </g:if>
                                                                </g:each>
                                                            </select>
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
                                                <g:if test="${juicio.materia?.id == 1}">
                                                    <label class="col-md-2 control-label">Tercero Interesado</label>
                                                    <div class="col-md-3">
                                                        <div id="listaTerceros" class="input-group">
                                                            <select style='width:335px;font-size:12px;' class='form-control' readOnly multiple>
                                                                <g:each var='actor' in='${actores}'>
                                                                    <g:if test="${actor.tipoDeParte.id == 3}">
                                                                        <option>${actor.persona}</option>
                                                                    </g:if>
                                                                </g:each>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </g:if>
                                                <g:if test="${juicio.materia?.id == 1}">    
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Fecha de Remisión al Despacho </label>
                                                </g:if>
                                                <g:else>
                                                    <label class="col-md-2 col-lg-offset-6 control-label">Fecha de Remisión al Despacho </label>
                                                </g:else>
                                                <div class="col-md-3">
                                                    <div class="input-group" >
                                                        <input id="tipoDeProcedimiento" style="width:270px;" readOnly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${formatDate(format:'dd/MM/yyyy',date: juicio?.fechaRD)}">   
                                                    </div>  
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Despacho </label>
                                                <div class="col-md-3">
                                                    <g:select noSelection="['':'Elija el Despacho...']" data-placeholder="Elija el Despacho..." class="chosen-select" id="despacho" name="despacho.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" value="${juicio.despacho?.id}" from="${listaDespachos}" optionKey="id" onchange = "${remoteFunction(controller : 'despacho', action : 'getDatosDespachoSeleccionado', params : '\'despacho=\' + escape(this.value)', onSuccess : 'actualizarDespInfo(data)')}" />     
                                                </div>
                                                <label class="col-md-2 col-lg-offset-1 control-label">Número(s) de Crédito</label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <input id="numeroDeCredito" name='numeroDeCredito' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" value="${numerosDeCredito}"/>    
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 control-label">Responsable del Despacho </label>
                                                <div class="col-md-3">
                                                    <input id="responsableDelDespacho" style="width:300px;" readonly type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" value="${responsableDelDespacho}"/>    
                                                </div>
                                                <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                    <label class="col-md-2 col-lg-offset-1 control-label">Prestaciones Reclamadas *</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <g:select noSelection="['':'Elija la Prestación Reclamada...']" data-placeholder="Elija la Prestación Reclamada..." class="chosen-select" style="width:300px;" tabindex="2" name="prestacionReclamada.id" value="${prestacionReclamada?.id}" id="prestacionReclamada" from="${mx.gox.infonavit.sicj.catalogos.PrestacionReclamada.findAll("from PrestacionReclamada pr where pr.materia.id = :idMateria and pr.id > 0 order by pr.nombre", [idMateria: juicio.materia.id])}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerTiposAsociados', params : '\'prestacionReclamada=\' + escape(this.value)', onSuccess : 'mostrarChecks(data,\'tiposAsociados\')')}"/>
                                                            </div>
                                                        </div>
                                                </g:if>
                                                <g:elseif test="${juicio.materia?.id == 3}">
                                                    <label class="col-md-2  col-lg-offset-1 control-label">Tipo de Asignación *</label>
                                                    <div class="col-md-3">
                                                        <div class="input-group">
                                                            <div class="row">
                                                                <g:select noSelection="['':'Elija el Tipo de Asignación...']" data-placeholder="Elija el Tipo de Asignación..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeAsignacion.id" id="tipoDeAsignacion" value="${prestacionReclamada?.id}" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAsignacion?.list(sort:'nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerDelitos', params : '\'tipoDeAsignacion=\' + escape(this.value)', onSuccess : 'mostrarChecks(data,\'delitos\')')}"/>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <br />
                                                            <input id="numeroDeAsignacion" name='numeroDeAsignacion' type="text" placeholder="Indique el numero de asignacion" size="150" class="form-control" maxlength="30" onBlur="this.value=this.value.toUpperCase();" value="${juicio.expediente}" style="text-transform: uppercase"/> 
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
                                            <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                <label class="col-md-2 col-lg-offset-1 control-label">Tipos Asociados *</label>
                                            </g:if>
                                            <g:elseif test="${juicio.materia?.id == 3}">
                                                <label class="col-md-2 col-lg-offset-1 control-label">Delitos *</label>
                                            </g:elseif>
                                            <div class="col-md-3">
                                                <div id="checkBoxes" class="input-group">
                                                    <g:if test="${juicio.materia.id == 3}">
                                                        <g:each var="delito" in="${mx.gox.infonavit.sicj.catalogos.Delito.findAllByTipoDeAsignacion(prestacionReclamada,[sort:'nombre'])}">
                                                            <div class='row'>
                                                                <div class='checkbox checkbox-primary checkbox-circle col-md-12'>
                                                                    <input type='checkbox' id='DELITO_${delito.id}' name='DELITO_${delito.id}' <g:if test="${delitosJuicio*.id.contains(delito.id)}">checked</g:if> />
                                                                    <label style='width: 300px;' for='DELITO_${delito.id}'>${delito.nombre}</label>
                                                                </div>
                                                            </div>
                                                        </g:each>
                                                    </g:if>
                                                    <g:else>
                                                        <g:each var="tipoAsociado" in="${mx.gox.infonavit.sicj.catalogos.TipoAsociado.findAllByPrestacionReclamada(prestacionReclamada,[sort:'nombre'])}">
                                                            <div class='row'>
                                                                <div class='checkbox checkbox-primary checkbox-circle col-md-12'>
                                                                    <input type='checkbox' id='TASOCIADO_${tipoAsociado.id}' name='TASOCIADO_${tipoAsociado.id}' <g:if test="${tiposAsociadosJuicio*.id.contains(tipoAsociado.id)}">checked</g:if> />   
                                                                    <label style='max-width:300px; width:300px;' for='TASOCIADO_${tipoAsociado.id}'>${tipoAsociado.nombre}</label>
                                                                </div>
                                                            </div>
                                                            <g:if test="${tipoAsociado.nombre == 'OTRO'}" > 
                                                                <g:if test="${tiposAsociadosJuicio*.id.contains(tipoAsociado.id)}">
                                                                    <input type="hidden" name="tipoAsociadoOtro" id="tipoAsociadoOtro" value="${tipoAsociado.nombre}">
                                                                </g:if>
                                                            </g:if>
                                                        </g:each>
                                                    </g:else>
                                                </div>
                                                <div class="row" id="divCampoOtro" style="display: none;">
                                                    <br />
                                                    <input id="otro" name='otro' type="text" placeholder="Indique cual" size="150" class="form-control" maxlength="30" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"/> 
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}"> 
                                                <label class="col-md-2 control-label">Municipio </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <g:select noSelection="['':'Elija el Municipio...']" data-placeholder="Elija el Municipio..." class="chosen-select" id="municipioAutoridad" name="municipioAutoridad.id" from="${listaMunicipios}" optionKey="id" value="${juicio.municipioAutoridad?.id}" style="width:300px;" tabindex="2" onchange = "consultarJuzgados(escape(this.value));" />
                                                        <!--select class="chosen-select" id="municipioAutoridad" name="municipioAutoridad.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2" onchange = "consultarJuzgados(escape(this.value));" >
                                                        </select--> 
                                                    </div>
                                                </div>
                                            </g:if>
                                            <g:elseif test="${juicio.materia?.id == 3}">
                                                <label class="col-md-2 control-label">Municipio </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <g:select noSelection="['':'Elija el Municipio...']" data-placeholder="Elija el Municipio..." class="chosen-select" id="municipioAutoridad" name="municipioAutoridad.id" from="${listaMunicipios}" optionKey="id" value="${juicio.municipioAutoridad?.id}" style="width:300px;" tabindex="2" onchange = "consultarJuzgados(escape(this.value));" />
                                                        <!--select class="chosen-select" id="municipioAutoridad" required name="municipioAutoridad.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2" onchange = "consultarAutoridades('municipio',escape(this.value));" >
                                                        </select-->
                                                    </div>
                                                </div>
                                            </g:elseif>    
                                            <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 3}"> 
                                                <label class="col-md-2 col-lg-offset-1 control-label">Antecedentes</label>
                                            </g:if>
                                            <g:else>
                                                <label class="col-md-2 col-lg-offset-6 control-label">Antecedentes</label>
                                            </g:else>
                                            <div class="col-md-3">
                                                <textarea rows="4" cols="80" style="width: 300px;" id="antecedentes" name='antecedentes' placeholder="Escriba los antecedentes del caso" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase">${juicio.antecedentes}</textarea>   
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="row">
                                            <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}"> 
                                                <label class="col-md-2 control-label">Juzgado</label>
                                                <div class="col-md-3">
                                                    <g:select noSelection="['':'Elija el Juzgado...']" data-placeholder="Elija el Juzgado..." class="chosen-select" id="juzgado" name="juzgado.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" value="${juicio.autoridad?.tipoDeAutoridad?.id}" from="${listaJuzgados}" optionKey="id" tabindex="2" onchange = "consultarAutoridades('juzgado',escape(this.value));"/>
                                                    <!--select class="chosen-select" id="juzgado" required name="juzgado.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" tabindex="2" onchange = "consultarAutoridades('juzgado',escape(this.value));">
                                                    </select--> 
                                                </div>
                                            </g:if>
                                            <g:elseif test="${juicio.materia?.id == 3}">
                                                <div id="divAutoridades">
                                                    <label class="col-md-2 control-label">Autoridad Ministerial Investigadora</label>
                                                    <div class="col-md-10">
                                                        <g:select noSelection="['':'Elija la Autoridad...']" data-placeholder="Elija la Autoridad..." class="chosen-select" id="autoridad" name="autoridad.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" value="${juicio.autoridad?.id}" from="${listaAutoridades}" optionKey="id" tabindex="2" /> 
                                                    </div> 
                                                </div>
                                            </g:elseif>
                                            <g:if test="${juicio.materia?.id == 1}">
                                                <label class="col-md-2 col-lg-offset-1 control-label">Patrocinador del Juicio * </label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <g:select noSelection="['':'Elija al Patrocinador...']" data-placeholder="Elija al Patrocinador..." class="chosen-select" style="width:300px;" tabindex="2" name="patrocinadoDelJuicio.id" id="patrocinadoDelJuicio" from="${mx.gox.infonavit.sicj.catalogos.PatrocinadorDelJuicio?.list(sort: 'nombre')}" value="${juicio?.patrocinadoDelJuicio?.id}" optionKey="id" />
                                                    </div>
                                                </div>
                                            </g:if>
                                        </div>
                                    </div>
                                    <g:if test="${juicio.materia?.id == 3}">
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
                                                <label class="col-md-2 col-lg-offset-1 control-label">Número de Causa Penal </label>
                                                <div class="col-md-3">
                                                    <input id="numeroDeCausaPenal" name="numeroDeCausaPenal" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.numeroDeCausaPenal}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <label class="col-md-2 col-lg-offset-6 control-label">Juzgado </label>
                                                <div class="col-md-3">
                                                    <input id="juzgadoAsignado" name="juzgadoAsignado" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.juzgadoAsignado}">
                                                </div>
                                                <label class="col-md-2 col-lg-offset-1 control-label">Otros</label>
                                                <div class="col-md-3">
                                                    <input id="otraInstancia" name="otraInstancia" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.otraInstancia}"> 
                                                </div>
                                            </div>
                                        </div>
                                    </g:if>
                                    <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                        <div class="form-group">
                                            <div id="divAutoridades" class="row">
                                                <label class="col-md-2 control-label">Autoridad</label>
                                                <div class="col-md-10">
                                                    <g:select noSelection="['':'Elija la Autoridad...']" data-placeholder="Elija la Autoridad..." class="chosen-select" id="autoridad" name="autoridad.id" data-placeholder="Elija primero el Juzgado..." value="${juicio.autoridad?.id}" from="${listaAutoridades}" optionKey="id" style="width:300px;" tabindex="2" />
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
                                                            <g:select noSelection="['':'Elija el Estado...']" data-placeholder="Elija el Estado..." class="chosen-select" style="width:300px;" tabindex="2" name="ubicacionEstado.id" id="ubicacionEstado" from="${mx.gox.infonavit.sicj.catalogos.Estado?.list(sort:nombre)}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerMunicipios', params : '\'estado=\' + escape(this.value)', onSuccess : 'actualizar(data,\'ubicacionMunicipio\')')}"/>
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
                                            <g:if test="${juicio.materia?.id == 1 || juicio.materia?.id == 2}">
                                                <label class="col-md-2 control-label">Cantidad Demandada</label>
                                                <div class="col-md-4">
                                                    <div class="input-group">
                                                        <div class="row" style="margin-left: 5px;">
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="cantidadDemandada" id="cantidadDemandadaNo" value="NO" onclick="ocultarMonto();" <g:if test="${!juicio.cantidadDemandada}"> checked </g:if> >
                                                                    <label for="cantidadDemandadaNo">
                                                                    No Aplica
                                                                </label>
                                                            </div>
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="cantidadDemandada" id="cantidadDemandadaSi" value="SI" onclick="mostrarMonto();" <g:if test="${juicio.cantidadDemandada}"> checked </g:if> >
                                                                    <label for="cantidadDemandadaSi">
                                                                    Si
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div id="divMonto" class="row">
                                                            <br />
                                                            <input id="monto" name='monto' type="text" placeholder="Indique el monto sin decimales" style="width: 300px;" class="form-control" maxlength="15" value="${juicio.monto}" onKeyPress="return numbersonly(this, event)"/> 
                                                        </div>
                                                        <!--<div id="divMoneda" class="row">
                                                            <br />
                                                            <g:select noSelection="['':'Elija el Tipo de Moneda...']" data-placeholder="Elija el Tipo de Moneda..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeMoneda.id" id="tipoDeMoneda" from="${mx.gox.infonavit.sicj.catalogos.TipoDeMoneda?.list(sort:'nombre')}" optionKey="id" />
                                                        </div>-->
                                                    </div>
                                                </div>
                                            </g:if>
                                            <g:elseif test="${juicio.materia?.id == 3}">
                                                <label class="col-md-2 control-label">Daño Patrimonial</label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <div class="row" style="margin-left: 5px;">
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="danoPatrimonial" id="danoPatrimonialNo" value="NO" onclick="ocultarMonto();" <g:if test="${!juicio.cantidadDemandada}"> checked </g:if> >
                                                                    <label for="danoPatrimonialNo">
                                                                    No Aplica
                                                                </label>
                                                            </div>
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="danoPatrimonial" id="danoPatrimonialSi" value="SI" onclick="mostrarMonto();" <g:if test="${juicio.cantidadDemandada}"> checked </g:if> >
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
                                            <g:if test="${juicio.materia?.id == 1}">
                                                <label class="col-md-2 control-label">¿Finado?</label>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <div class="row" style="margin-left: 5px;">
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="finado" id="finadoNo" value="NO" onclick="ocultarDatosFinado();" <g:if test="${!juicio.finado}"> checked </g:if> >
                                                                    <label for="finadoNo">
                                                                    No Aplica
                                                                </label>
                                                            </div>
                                                            <div class="radio radio-success radio-inline">
                                                                <input type="radio" name="finado" id="finadoSi" value="SI" onclick="mostrarDatosFinado();" <g:if test="${juicio.finado}"> checked </g:if> >
                                                                    <label for="finadoSi">
                                                                    Si
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div id="divNombreFinado" class="row">
                                                            <br />
                                                            <input id="nombreDelFinado" name='nombreDelFinado' type="text" placeholder="Escriba el nombre completo" style="width:300px;" size="150" class="form-control" value="${juicio.nombreDelFinado}" maxlength="100"/> 
                                                        </div>
                                                        <div id="divNssFinado" class="row">
                                                            <br />
                                                            <input id="numeroSeguroSocialDelFinado" name='numeroSeguroSocialDelFinado' type="text" pattern="\d*" maxlength="11" placeholder="Escriba el Número de Seguridad Social" style="width:300px;" size="150" class="form-control" value="${juicio.numeroSeguroSocialDelFinado}" maxlength="10" onKeyPress="return numbersonly(this, event)"/> 
                                                        </div>
                                                    </div>
                                                </div>
                                            </g:if>
                                        </div>
                                    </div>
                                    <div class="hr-line-dashed"></div>
                                    <div class="form-group">
                                        <div class="col-sm-4 col-sm-offset-2">
                                            <button class="btn btn-white" type="submit">Cancelar</button>
                                            <button class="btn btn-warning" type="submit">Guardar Cambios</button>
                                        </div>
                                    </div>
                                </fieldset>
                            </form>
                            <div class="modal inmodal fade" id="modalAltaRegion" tabindex="-1" role="dialog" aria-hidden="true">
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
                        </g:if>
                        <g:else>
                            <center>
                                <div class="alert alert-danger">
                                    ${mensaje}
                                </div>
                            </center>
                        </g:else>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function consultarJuzgados(municipio){
        var materia = $('#materiaJuicio').val();
        console.log ("materia-> " + materia);
        var ambito = $('#ambito').val();
        $.ajax({
        type:'POST',
        data:'municipio=' + municipio + '&materia=' + materia + "&ambito=" + ambito,
        url:'/sicj/juicio/obtenerJuzgadosEdicion',
        success:function(data,textStatus){
        actualizar(data,'juzgado');
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        }
        });
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
        
        function consultarAutoridades(tipo,valor){
        var materia = $('#materiaJuicio').val();
        console.log ("materia-> " + materia);
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
        url:'/sicj/juicio/obtenerAutoridadesEdicion',
        success:function(data,textStatus){
        actualizar(data,'autoridad');
        redimensionarChosen('divAutoridades');
        },error:function(XMLHttpRequest,textStatus,errorThrown){
        }
        });
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

        function mostrarDatosDeUbicacion(){
        $('#ubicacionForm').show('slow');
            $('#actionInmueble').html("<a class='btn btn-white btn-bitbucket' onClick='ocultarDatosDeUbicacion();'><i class='fa fa-minus'></i></a>");
        }

        function ocultarDatosDeUbicacion(){
        $('#ubicacionForm').hide('slow');
            $('#actionInmueble').html("<a class='btn btn-white btn-bitbucket' onClick='mostrarDatosDeUbicacion();'><i class='fa fa-plus'></i></a>");
        }

        function obtenerRegiones(){
        jQuery.ajax({
        type:'GET',
        url:'/sicj/region/obtenerRegiones',
        success:function(data,textStatus){
        actualizar(data, 'region');
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){}
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
        
        function redimensionarChosen(idDiv){
        $('#'+idDiv+" .chosen-container").css('width', '95%');
        //$('#'+idDiv+" .chosen-container").css('font-size', '11px');
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
        } 

        function ocultarDatosFinado() {
        $('#divNombreFinado').hide('slow');
        $('#divNssFinado').hide('slow');
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function(){
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
        if($("input:radio[name=danoPatrimonial]:checked").val() == 'NO' || $("input:radio[name=cantidadDemandada]:checked").val() == 'NO'){
        $('#divMonto').hide();
        }
        if($("input:radio[name=finado]:checked").val() == 'NO'){
        $('#divNombreFinado').hide();
        $('#divNssFinado').hide();
        }
        $('#autoridad').trigger("chosen:updated");
        if($("input:hidden[name=tipoAsociadoOtro]").val() == 'OTRO'){
            console.log("ENTRO");
            if ( $('#divCampoOtro').css('display') === 'none' ){
            $('#divCampoOtro').show('slow');
            }        
        } else {
            console.log("NO ESTA ENTRANDO " + $("input:hidden[name=tipoAsociadoOtro]").val);
        }
        });
    </script>
</body>
</html>
