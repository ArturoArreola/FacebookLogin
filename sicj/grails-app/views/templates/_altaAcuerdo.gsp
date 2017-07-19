<g:form action="agregarAcuerdo" method="POST" id="modalAcuerdoForm" name="modalAcuerdoForm" enctype="multipart/form-data" useToken="true">
    <input type="hidden" name="acuerdoJuicioId" id="acuerdoJuicioId" value="${juicio.id}"/>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Fecha de Publicación o Notificación*</label>
                <div id="fechaDePublicacion" class="input-group date datepicker">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly required name="fechaDePublicacion" id="fechaDePublicacion" type="text" class="form-control" value="">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Observaciones </label>
                <div class="input-group">
                    <textarea rows="4" cols="80" required style="width: 300px;" id="observaciones" name='observaciones' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Archivo *</label>
                <div class="input-group">
                    <input style="width: 300px;" required name="archivoAcuerdo" id="archivoAcuerdo" type="file" class="form-control" accept=".pdf">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Guardar</button>
            </div>
        </div>
    </div>
</g:form>