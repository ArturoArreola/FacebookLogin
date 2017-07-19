<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <g:if test="${pagosRegistrados >= 0 && pagosRegistrados < 4}">
                    <g:form action="agregarPago" method="POST" id="modalPagoForm" name="modalPagoForm" class="form-horizontal">
                        <input type="hidden" name="pagoJuicioId" id="pagoJuicioId" value="${juicio.id}"/>
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="col-md-4 control-label">Número de Pago *</label>
                                <div class="col-md-7">
                                    <select class="form-control" name="numeroDePago" class="chosen-select" style="width:260px;" >
                                        <option value="1" <g:if test="${pagosRegistrados == 0}"> selected </g:if><g:else> disabled </g:else> >1er Pago</option>
                                        <option value="2" <g:if test="${pagosRegistrados == 1}"> selected </g:if><g:else> disabled </g:else>>2do Pago</option>
                                        <option value="3" <g:if test="${pagosRegistrados == 2}"> selected </g:if><g:else> disabled </g:else>>3er Pago</option>
                                        <option value="4" <g:if test="${pagosRegistrados == 3}"> selected </g:if><g:else> disabled </g:else>>4to Pago</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label class="col-md-4 control-label">Importe del Pago *</label>
                                    <div class="col-md-7">
                                        <input type="number" class="form-control" name='montoDelPago' id="montoDelPago" size='50' maxlength='30' autocomplete='off' onBlur="this.value=this.value.toUpperCase();" onKeyPress="return numbersonly(this, event)"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-12">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Fecha del Pago *</label>
                                    <div id="fechaDePago" class="input-group date datepicker" style="padding-left: 15px;">
                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly required name="fechaDelPago" id="fechaDelPago" type="text" class="form-control" value="">
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
                </g:if>
                <g:else>
                    <center>
                        <div class="alert alert-info">
                            No es posible registrar pagos del juicio. Consulte la lista de pagos registrados.
                        </div>
                    </center>
                </g:else>
            </div>
        </div>
    </div>
</div>