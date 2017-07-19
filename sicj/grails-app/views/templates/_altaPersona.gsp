<div id='mensajesAltaPersona' class='row'></div>
<g:form id="modalPersonaForm" name="modalPersonaForm">
    <input type="hidden" name="tipoDeActor" id="tipoDeActor" />
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Tipo de Persona *</label>
                <div class="input-group">
                    <g:select noSelection="['':'Elija el Tipo de Persona...']" required data-placeholder="Elija el Tipo de Persona..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDePersona.id" id="tipoDePersona" from="${mx.gox.infonavit.sicj.catalogos.TipoDePersona?.list(sort: 'nombre')}" optionKey="id" onchange="habilitarCamposPersona(this.value);" />
                </div>
            </div>
        </div>
    </div>
    <div id="divNombrePersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Nombre *</label>
                <div class="input-group">
                    <input id="nombre" name="nombre" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                </div>
            </div>
        </div>
    </div>
    <div id="divAPPersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Apellido Paterno *</label>
                <div class="input-group">
                    <input id="apellidoPaterno" name="apellidoPaterno" required maxlength="80" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                </div>
            </div>
        </div>
    </div>
    <div id="divAMPersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Apellido Materno </label>
                <div class="input-group">
                    <input id="apellidoMaterno" name="apellidoMaterno" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                </div>
            </div>
        </div>
    </div>
    <div id="divRFCPersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>R.F.C.</label>
                <div class="input-group">
                    <input id="rfc" name="rfc" maxlength="13" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                </div>
            </div>
        </div>
    </div>
    <div id="divNSSPersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Número de Seguridad Social</label>
                <div class="input-group">
                    <input id="numeroSeguroSocial" name="numeroSeguroSocial" style="width: 300px; text-transform: uppercase" type="text" pattern="\d*" maxlength="11" class="form-control" onBlur="this.value=this.value.toUpperCase();" onKeyPress="return numbersonly(this, event)">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <button class="btn btn-warning" type="reset" onclick="limpiarFormularioPersona();">Limpiar</button>
                <g:submitToRemote onSuccess="agregarNuevaPersona(data);" onFailure="alert('algo fallo');" class="btn btn-primary" url="[controller: 'persona',action: 'save']" method="POST" value="Guardar"/>
            </div>
        </div>
    </div>
</g:form>