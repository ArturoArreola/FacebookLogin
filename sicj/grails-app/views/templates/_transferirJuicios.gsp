<g:form class="form-horizontal">
    <fieldset class="col-md-12">
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">¿Qué tipo de reasignación desea realizar? </label>
                <div class="col-md-9">
                    <select class="chosen-select" id="opcion" name="opcion.id" data-placeholder="Elija la opción deseada..." style="width:300px;" tabindex="2" onchange = "cambiarTrigger(this.value);" >
                        <option disabled selected value> -- Seleccione una opción -- </option>
                        <option value="1">DESPACHO A DESPACHO (POR BLOQUE)</option>
                        <option value="2">DESPACHO A DESPACHO (TOTAL)</option>
                        <option value="3">DELEGACION A DELEGACION (SIN DESPACHO)</option>
                        <option value="4">DELEGACION A DESPACHO</option>
                    </select>     
                </div>
            </div>
        </div>
    </fieldset>    
    <fieldset class="col-md-6">
        <div class="form-group">
            <div class="row text-center">
                <label class="col-md-12 label label-primary">Origen</label>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Delegación</label>
                    <g:if test="${despacho}">
                        <div class="col-md-7">
                        <input type="hidden" name ="delegacionOrigen.id" value="${despacho.delegacion.id}" >
                        <input id="delegacionOrigen" name="delegacionOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${despacho?.delegacion}">
                    </g:if>
                    <g:else>
                        <div class="col-md-4">
                        <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacionOrigen.id" id="delegacionOrigen" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'id')}" optionKey="id" onchange = "${remoteFunction(controller : 'delegacion', action : 'getDatosDelegacionSeleccionada', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizarDelInfo(data,\'Origen\')')}" />
                    </g:else> 
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Despacho </label>
                    <g:if test="${despacho}">
                        <div class="col-md-7">
                        <input type="hidden" name ="despachoOrigen.id" value="${despacho.id}" >
                        <input id="despachoOrigen" name="despachoOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${despacho}">
                    </g:if>
                    <g:else>
                        <div class="col-md-4">
                        <select class="chosen-select" id="despachoOrigen" name="despachoOrigen.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" onchange = "${remoteFunction(controller : 'despacho', action : 'getDatosDespachoSeleccionado', params : '\'despacho=\' + escape(this.value)', onSuccess : 'actualizarDespInfo(data,\'Origen\')')}" >
                        </select>
                    </g:else>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label"> Responsable del Despacho </label>
                <div class="col-md-7">
                    <g:if test="${despacho}">
                        <input id="responsableDelDespachoOrigen" name="responsableDelDespachoOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="<g:if test="${responsableDelDespacho}">${responsableDelDespacho?.nombre + " " + responsableDelDespacho?.apellidoPaterno + " " + responsableDelDespacho?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else>">
                    </g:if>
                    <g:else>
                        <input id="responsableDelDespachoOrigen" name="responsableDelDespachoOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                    </g:else>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Gerente Jurídico </label>
                <div class="col-md-7">
                    <g:if test="${despacho}">
                        <%def gerenteJuridico = mx.gox.infonavit.sicj.admin.Delegacion.getGerenteJuridico(despacho.delegacion.id) %>
                        <input id="gerenteJuridicoOrigen" name="gerenteJuridicoOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="<g:if test="${gerenteJuridico}">${gerenteJuridico?.nombre + " " + gerenteJuridico?.apellidoPaterno + " " + gerenteJuridico?.apellidoMaterno}</g:if><g:else>No se ha indicado</g:else>">
                    </g:if>
                    <g:else>
                        <input id="gerenteJuridicoOrigen" name="gerenteJuridicoOrigen" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
                    </g:else>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Fecha de Actualización </label>
                <div class="col-md-7">
                    <input style="text-align: center;" readOnly name="fecha" id="fecha" type="text" class="form-control" value="${formatDate(format:'dd/MM/yyyy',date:new Date())}">
                </div>
            </div>
        </div>
        <div class="form-group" id="mostrarCantidadJuicios" style="display: none">
            <div class="row">
                <label class="col-md-3 control-label" >Cantidad de juicios a actualizar</label>
                <div class="col-md-7">
                    <g:if test="${despacho}">
                        <input id="cantidadJuicios" name="cantidadJuicios" readonly style="text-align: center; font-weight: bold;" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                    </g:if>
                    <g:else>
                        <input id="cantidadJuicios" name="cantidadJuicios" readonly style="text-align: center; font-weight: bold;" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                    </g:else>
                </div>
            </div>
        </div>
    </fieldset>
    <fieldset class="col-md-6">
        <div class="form-group">
            <div class="row text-center">
                <label class="col-md-12 label label-success">Destino</label>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Delegación</label>
                <div class="col-md-4">
                    <div class="input-group">
                        <g:select noSelection="['':'Elija una Delegación...']" data-placeholder="Elija una Delegación..." class="chosen-select" style="width:300px;" tabindex="2" name="delegacionDestino.id" id="delegacionDestino" from="${mx.gox.infonavit.sicj.admin.Delegacion?.list(sort:'id')}" optionKey="id" onchange = "${remoteFunction(controller : 'delegacion', action : 'getDatosDelegacionSeleccionada', params : '\'delegacion=\' + escape(this.value)', onSuccess : 'actualizarDelInfo(data,\'Destino\')')}" />
                    </div>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Despacho </label>
                <div class="col-md-4">
                    <select class="chosen-select" id="despachoDestino" name="despachoDestino.id" data-placeholder="Elija primero la Delegacion..." style="width:300px;" tabindex="2" onchange = "${remoteFunction(controller : 'despacho', action : 'getDatosDespachoSeleccionado', params : '\'despacho=\' + escape(this.value)', onSuccess : 'actualizarDespInfo(data,\'Destino\')')}" >
                    </select>     
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label"> Responsable del Despacho </label>
                <div class="col-md-7">
                    <input id="responsableDelDespachoDestino" name="responsableDelDespachoDestino" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Lista de Usuarios </label>
                <div class="col-md-9">
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
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="row">
                <label class="col-md-3 control-label">Gerente Jurídico </label>
                <div class="col-md-7">
                    <input id="gerenteJuridicoDestino" name="gerenteJuridicoDestino" readonly style="text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${juicio?.expediente}">
                </div>
            </div>
        </div>
    </fieldset>
    <div id="manualTrigger" class="form-group text-center" style="display: none;">
        <div class="col-md-12">
            <button class="btn btn-warning" type="reset" onclick="$('#resultados').html('');">Limpiar</button>
            <g:submitToRemote onSuccess='mostrarMensaje(data)' onFailure="alert('algo fallo');" onComplete="" class="btn btn-primary" url="[controller: 'juicio',action: 'verificarReasignacion']" update="resultados" method="POST" value="Buscar"/>
        </div>
    </div>
    <div id="mensajesAlert"></div>
</g:form>
<script type="text/javascript">
    function actualizarDelInfo(data,componente) {
    var resultado = eval(data);
    $('#gerenteJuridico'+componente).val(resultado.gerenteJuridico);
    $.ajax({
    type:'POST',
    data:'delegacion=' + $('#delegacion'+componente).val(), 
    url:'/sicj/despacho/obtenerDespachos',
    success:function(data,textStatus){
    actualizar(data, ('despacho'+componente));},
    error:function(XMLHttpRequest,textStatus,errorThrown){}
    });
    }

    function actualizarDespInfo(data, componente) {
    var resultado = eval(data);
    $('#responsableDelDespacho'+componente).val(resultado.responsableDelDespacho);
    $.ajax({
    type:'POST',
    data:'despacho=' + $('#despacho'+componente).val(), 
    url:'/sicj/despacho/obtenerUsuariosActivosDelDespacho',
    success:function(data,textStatus){
    mostrarUsuariosDespacho(data);},
    error:function(XMLHttpRequest,textStatus,errorThrown){}
    });
    $.ajax({
    type:'POST',
    data:'despacho=' + $('#despacho'+componente).val() + '&delegacion=' + $('#delegacion'+componente).val(),
    url:'/sicj/juicio/obtenerCantidadJuicios',
    dataType:"json",
    success:function(data,textStatus){
    mostrarCantidadJuicios(data);},
    error:function(XMLHttpRequest,textStatus,errorThrown){}
    });
    }
    
    function mostrarCantidadJuicios(data){
    var resultado = eval(data);
    $('#cantidadJuicios').val(resultado.cantidadJuicios);
    }
    
    function mostrarMensaje(data){
    var resultado = eval(data);
    if (resultado.queryJuicioOrigen !== null){
    $('#mensajesAlert').html("<center><div class='alert alert-success'><strong>Los juicios se han reasignado de manera correcta</strong></div></center>");
    } else {
    $('#mensajesAlert').html("<center><div class='alert alert-warning'><p><strong>No se encontraron juicios para poder realizar la reasignación</strong></p></br><p>Por favor verifique que los campos de origen y destino de la delegación y despacho hayan sido seleccionados de manera correcta</p></div></center>");
    }
    }
   
    function mostrarUsuariosDespacho(data) {
    var resultado = eval(data);
    var html = "";
    for (var x = 0; x < resultado.length; x++) {          
            html += "<tr><td>"+resultado[x].nombre+" " + resultado[x].apellidoPaterno + " "+resultado[x].apellidoMaterno+"</td></tr>";
    }
    $('#usuariosDelDespacho tbody').html(html);
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
    
    function cambiarTrigger(valor) {
    if(valor == 2){
    $('#cargaArchivos').hide('slow');
    $('#manualTrigger').show('slow');
    $('#mostrarCantidadJuicios').show('slow');
    $('#despachoOrigen').attr("enabled", "enabled");
    $('#despachoDestino').attr("enabled", "enabled"); 
    } 
    else if(valor == 3) {
    $('#despachoOrigen').attr("disabled", "disabled");
    $('#despachoDestino').attr("disabled", "disabled");   
    }
    else if(valor == 4) {
    $('#despachoOrigen').attr("disabled", "disabled");
    $('#despachoDestino').attr("enabled", "enabled"); 
    }
    else {
    $('#cargaArchivos').show('slow');
    $('#manualTrigger').hide('slow');
    $('#mostrarCantidadJuicios').hide('slow');
    $('#despachoOrigen').attr("enabled", "enabled");
    $('#despachoDestino').attr("enabled", "enabled"); 
    
    }
    }
</script>
