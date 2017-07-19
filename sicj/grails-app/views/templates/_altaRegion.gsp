<g:form>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Nombre de la Región *</label>
                <input id="nombre" name="nombre" type="text" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" class="form-control" required />
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <g:submitToRemote onSuccess="seleccionarNuevaRegion(data);" onFailure="alert('algo fallo');" onComplete="ocultarModal();" class="btn btn-primary" url="[controller: 'region',action: 'save']" method="POST" value="Guardar"/>
            </div>
        </div>
    </div>
</g:form>