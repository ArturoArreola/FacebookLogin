<div class="hr-line-dashed"></div>
<input type="hidden" name="id" id="idPersona" value="${persona.id}">
<div class="form-group">
    <label class="col-md-4 control-label">Tipo de Persona: </label>
    <div class="col-lg-8">
        <div class="input-group">
            <g:select noSelection="['':'Elija el Tipo de Persona...']" required data-placeholder="Elija el Tipo de Persona..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDePersona.id" id="tipoDePersona" from="${mx.gox.infonavit.sicj.catalogos.TipoDePersona?.list(sort: 'nombre')}" optionKey="id" value="${persona.tipoDePersona.id}"/>
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-md-4 control-label">Nombre: </label>
    <div class="col-lg-8">
        <div class="input-group">
            <input id="nombre" name="nombre" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${persona.nombre}">
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-md-4 control-label">Apellido Paterno: </label>
    <div class="col-lg-8">
        <div class="input-group">
            <input id="apellidoPaterno" name="apellidoPaterno" required maxlength="80" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${persona.apellidoPaterno}">
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-md-4 control-label">Apellido Materno: </label>
    <div class="col-lg-8">
        <div class="input-group">
            <input id="apellidoMaterno" name="apellidoMaterno" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${persona.apellidoMaterno}">
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-md-4 control-label">R.F.C.: </label>
    <div class="col-lg-8">
        <div class="input-group">
            <input id="rfc" name="rfc" maxlength="13" style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${persona.rfc}">
        </div>
    </div>
</div>
<div class="form-group">
    <label class="col-md-4 control-label">Número de Seguridad Social (NSS): </label>
    <div class="col-lg-8">
        <div class="input-group">
            <input id="numeroSeguroSocial" name="numeroSeguroSocial" style="width: 300px; text-transform: uppercase" type="text" pattern="\d*" onKeyPress="return numbersonly(this, event)" maxlength="11" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${persona.numeroSeguroSocial}">
        </div>
    </div>
</div>
<div class="form-group text-center">
    <div class="col-lg-12">
        <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i>&nbsp;&nbsp;Guardar cambios</button>
    </div>
</div>
