<g:form action="agregarPromocion" method="POST" id="modalPromocionForm" name="modalPromocionForm" enctype="multipart/form-data" useToken="true">
    <input type="hidden" name="promocionJuicioId" id="promocionJuicioId" value="${juicio.id}"/>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Tipo de Parte *</label>
                <div class="input-group">
                    <g:select noSelection="['':'Elija el Tipo de Parte...']" required data-placeholder="Elija el Tipo de Parte..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeParte.id" id="tipoDeParte" from="${(mx.gox.infonavit.sicj.catalogos.TipoDeParteMateria?.findAllByMateria(juicio.materia))*.tipoDeParte.sort{it.nombre}}" optionKey="id" onchange="habilitarCamposPersona(this.value);" />
                </div>
            </div>
        </div>
    </div>
    <g:if test="${juicio.materia.id == 1 || juicio.materia.id == 2}">
        <div id="divNombrePersona" class="row">
            <div class="col-lg-6">
                <div class="form-group">
                    <label>Observaciones </label>
                    <div class="input-group">
                        <textarea rows="4" cols="80" style="width: 300px;" required id="observaciones" name='observaciones' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                    </div>
                </div>
            </div>
        </div>
    </g:if>
    <div id="divAPPersona" class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Archivo *</label>
                <div class="input-group">
                    <input style="width: 300px;" required name="archivoPromocion" id="archivoPromocion" type="file" class="form-control" accept=".pdf">
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <label>Fecha de Presentación *</label>
                <div id="fechaDePublicacion" class="input-group date datepicker">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly required name="fechaDePresentacion" id="fechaDePresentacion" type="text" class="form-control">
                </div>
            </div>
        </div>
    </div>
    <g:if test="${juicio.materia.id == 3}">
        <div class="row">
            <div class="col-lg-6">
                <div class="form-group">
                    <label>Fecha de Promoción *</label>
                    <div id="fechaDePublicacion" class="input-group date datepicker">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly required name="fechaDePromocion" id="fechaDePromocion" type="text" class="form-control">
                    </div>
                </div>
            </div>
        </div>
        <div id="divNombrePersona" class="row">
            <div class="col-lg-6">
                <div class="form-group">
                    <label>Resumen de la Promoción </label>
                    <div class="input-group">
                        <textarea rows="4" cols="80" style="width: 300px;" required id="resumenDeLaPromocion" name='resumenDeLaPromocion' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                    </div>
                </div>
            </div>
        </div>
    </g:if>
    <div class="row">
        <div class="col-lg-6">
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Guardar</button>
            </div>
        </div>
    </div>
</g:form>