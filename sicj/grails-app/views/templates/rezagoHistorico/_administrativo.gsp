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
            <label class="col-md-2 col-lg-offset-1 control-label">Acreditado *</label>
            <div class="col-md-3">
                <input id="acreditado" required name="acreditado" style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.acreditado}">
            </div>
        </div>
    </div>
    <div class="form-group">
        <div class="row">
            <label class="col-md-2 control-label">Zona </label>
            <div class="col-md-3">
                <input id="zona" name="zona" style="width:300px;" readOnly style="text-transform: uppercase" type="text" class="form-control" />
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
            <label class="col-md-2 control-label">Fecha de Envío al Proveedor *</label>
            <div class="col-md-3">
                <div class="form-group" id="data_1">
                    <div class="input-group date">
                        &nbsp;&nbsp;&nbsp;<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 73%;" required readOnly name="fechaRD" id="fechaRD" type="text" class="form-control">
                    </div>
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
            <label class="col-md-2 control-label">Proveedor Asignado *</label>
            <div class="col-md-3">
                <select class="chosen-select" id="despacho" name="despacho.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" onchange = "consultarDespacho(escape(this.value));" >
                </select>     
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
    <div class="hr-line-dashed"></div>
    <div class="form-group">
        <div class="col-sm-4 col-sm-offset-2">
            <button class="btn btn-white" type="button">Cancelar</button>
            <button class="btn btn-primary" type="submit">Guardar</button>
        </div>
    </div>
</fieldset>