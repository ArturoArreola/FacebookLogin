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
                    <sec:ifAnyGranted roles='ROLE_ADMIN,ROLE_REZAGO_HISTORICO_NACIONAL'>  
                        <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacion.id" id="delegacion" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'nombre')}" value="${juicio?.delegacion?.id}" optionKey="id" onchange = "${remoteFunction(controller : 'delegacion', action : 'getDatosDelegacionSeleccionada', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizarDelInfo(data)')}"/>
                    </sec:ifAnyGranted>
                    <sec:ifNotGranted roles='ROLE_ADMIN,ROLE_REZAGO_HISTORICO_NACIONAL'>
                        <sec:ifAnyGranted roles='ROLE_REZAGO_HISTORICO'>  
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
            <label class="col-md-2 col-lg-offset-1 control-label">Expediente de Juicio * </label>
            <div class="col-md-3">
                <input id="expediente" required name="expediente" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
            </div>
        </div>
    </div>
    <div class="form-group">
        <div class="row">
            <label class="col-md-2 control-label">Zona </label>
            <div class="col-md-3">
                <input id="zona" name="zona" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" />
            </div>
            <label class="col-md-2 col-lg-offset-1 control-label">Ambito * </label>
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
            <label class="col-md-2 control-label">Fecha de Envío al Proveedor *</label>
            <div class="col-md-3">
                <div class="form-group" id="data_1">
                    <div class="input-group date">
                        &nbsp;&nbsp;&nbsp;<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 73%;" required readOnly name="fechaRD" id="fechaRD" type="text" class="form-control">
                    </div>
                </div>  
            </div>
            <label class="col-md-2 col-lg-offset-1 control-label">Acreditado *</label>
            <div class="col-md-3">
                <input id="acreditado" required name="acreditado" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.acreditado}">
            </div>
        </div>
    </div>
    <div class="form-group">
        <div class="row">
            <label class="col-md-2 control-label">Proveedor Asignado *</label>
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
                <label class="col-md-2 control-label">Proveedor Responsable </label>
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
            <label class="col-md-2 col-lg-offset-1 control-label">Año del Crédito *</label>
            <div class="col-md-3">
                <div class="input-group">
                     <% def anioActualParcial = Calendar.getInstance().get(Calendar.YEAR) %>
                    <g:select noSelection="['':'Elija el año del Crédito...']" data-placeholder="Elija el año del Crédito..." class="chosen-select" style="width:300px;" tabindex="2" name="anioDelCredito" id="anioDelCredito" from="${(anioActualParcial)..(anioActualParcial-120)}" />
                </div>
            </div>
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
            <label class="col-md-2 col-lg-offset-1 control-label">Prestaciones Reclamadas *</label>
            <div class="col-md-3">
                <div class="input-group">
                    <g:select noSelection="['':'Elija la Prestación Reclamada...']" data-placeholder="Elija la Prestación Reclamada..." class="chosen-select" style="width:300px;" tabindex="2" name="prestacionReclamada.id" id="prestacionReclamada" from="${mx.gox.infonavit.sicj.catalogos.PrestacionReclamada.findAll("from PrestacionReclamada pr where pr.materia.id = :idMateria and pr.id > 0 order by pr.nombre", [idMateria: materia.id])}" optionKey="id" onchange = "${remoteFunction(controller : 'juicio', action : 'obtenerTiposAsociados', params : '\'prestacionReclamada=\' + escape(this.value)', onSuccess : 'mostrarChecks(data,\'tiposAsociados\')')}"/>
                </div>
            </div>
        </div>
    </div>
    <div class="form-group">
        <div class="row">
            <label class="col-md-2 control-label">Municipio *</label>
            <div class="col-md-3">
                <div class="input-group">
                    <select class="chosen-select" id="municipioAutoridad" name="municipioAutoridad.id" data-placeholder="Elija primero la Delegación..." style="width:300px;" tabindex="2" onchange = "consultarJuzgados(escape(this.value));" >
                    </select>    
                </div>
            </div>
            <label class="col-md-2 col-lg-offset-1 control-label">Tipos Asociados *</label>
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
    <div class="form-group">
        <div class="row">
            <label class="col-md-2 control-label">Juzgado *</label>
            <div class="col-md-3">
                <select class="chosen-select" id="juzgado" required name="juzgado.id" data-placeholder="Elija primero el Municipio..." style="width:300px;" tabindex="2" onchange = "consultarAutoridades('juzgado',escape(this.value));">
                </select> 
            </div>
            <label class="col-md-2 col-lg-offset-1 control-label">Antecedentes</label>
            <div class="col-md-3">
                <textarea rows="4" cols="80" style="width: 300px;" id="antecedentes" name='antecedentes' placeholder="Escriba los antecedentes del caso" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea>   
            </div>
        </div>
    </div>
    <div class="form-group">
        <div id="divAutoridades" class="row">
            <label class="col-md-2 control-label">Autoridad *</label>
            <div class="col-md-10">
                <select class="chosen-select" id="autoridad" required name="autoridad.id" data-placeholder="Elija primero el Juzgado..." style="width:300px;" tabindex="2">
                </select> 
            </div> 
        </div>
    </div>
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
                </div>
            </div>
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