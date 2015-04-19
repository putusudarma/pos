{* Extend our master template *}
{extends file="../../../master.tpl"}

{block name=content}
    <!-- Default panel -->
    {js('function.js')}
    {js('form/po.js')}
    <div class="panel panel-default">

        <div class="panel-heading"><h6 class="panel-title">Purchase Order</h6></div>

        <div class="panel-body">
            <div class="block-inner">
                <h6 class="heading-hr">
                    <i class="icon-clipboard"></i> Purchase Info <small class="display-block">Informasi umum tentang proses purchasing</small>
                </h6>
            </div>
            <div class="row invoice-header">
                <div class="col-sm-6">
                    <h3>{$principal->name}</h3>
                    <span>{$principal->address} - {$principal->zipcode}
                        </br>
                        {$principal->city} - {$principal->state}
                        </br>
                        {$principal->telp1} - {$principal->telp1}
                        </br>
                        {$principal->email}
                    </span>
                </div>

                <div class="col-sm-6">
                    <ul class="invoice-details">
                        <li>Invoice # <strong class="text-danger">{$cache['value']['invoice_number']}</strong></li>
                        <li>Date of Invoice: <strong>{$cache['value']['date']}</strong></li>
                        <li>Due Date: <strong>{$cache['value']['due_date']}</strong></li>
                        <li class="invoice-status text-right">
                            <a href="{base_url('purchase-order/delete')}"  class=" button btn btn-danger"><i class="icon-eject"></i>New Purchase Order</a>
                        </li>
                    </ul>
                </div>
            </div>

            <hr>

            <!-- Callout -->
            {if $error}
                <div class="callout callout-danger fade in">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    <p>{$error}</p>
                </div>
            {/if}
            <!-- /callout -->

            <form action="{base_url('purchase-order/detail')}" role="form" method="post">
                <div class="form-group">
                    <div class="row">

                        <div class="col-md-4">
                            <label>Product:</label>
                            <script type="text/javascript">
                                var product_storage = {$product_storage|@json_encode};
                            </script>
                            {form_dropdown('id_product_select',$products,set_value('id_product'),'data-placeholder="Product" class="select-full" id="product-id-select" onchange="leaveDropdownProduct(this,product_storage,\'id_product\')"')}
                            {if form_error('id_product')}
                                <span class="label label-block label-danger text-left">{form_error('id_product') }</span>
                            {/if}
                            <input type="hidden" name="id_product" id="product-id" value="{set_value('id_product')}">
                        </div>
                        <div class="col-md-4">
                            <label>Barcode:</label>
                            {form_input('barcode', set_value('barcode'), 'class="form-control" placeholder="Type or scan barcode" id="product-barcode" autofocus onblur="leaveTextBarcode(this,product_storage,\'barcode\')"')}
                        </div>
                        <div class="col-md-4">
                            <label>Name:</label>
                            <input type="hidden" name="unit" id="product-unit" value="{set_value('unit')}">
                            <h6 id="product-name"></h6>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-4 {if form_error('qty')}has-warning{/if}">
                            <label>Qty:</label>
                            <input type="number" name="qty" value="{set_value('qty')}" class="form-control" placeholder="0" >
                            {if form_error('qty')}
                                <span class="label label-block label-danger text-left">{form_error('qty') }</span>
                            {/if}
                        </div>
                        <div class="col-md-4 {if form_error('price')}has-warning{/if}">
                            <label>Price:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="price" value="{set_value('price')}" class="form-control" placeholder="0" >

                            </div>
                            {if form_error('price')}
                            <span class="label label-block label-danger text-left">{form_error('price') }</span>
                            {/if}
                        </div>
                        <div class="col-md-4 {if form_error('discount_total')}has-warning{/if}">
                            <label>Discount Total:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="discount_total" value="{set_value('discount_total')}" class="form-control" placeholder="0" >
                            </div>
                            {if form_error('discount_total')}
                                <span class="label label-block label-danger text-left">{form_error('discount_total') }</span>
                            {/if}
                        </div>
                    </div>
                </div>
                <div class="form-actions text-right">
                    <input type="submit" value="Add" class="btn btn-success">
                </div>
            </form>
        </div><!-- /panel body -->


        {if !empty($cache['detail']['value'])}
            <div class="table-responsive pre-scrollable">
                <table class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th>No</th>
                        <th>Barcode</th>
                        <th>Name</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Total</th>
                        <th>Discount</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    {assign var=total value=0}
                    {assign var=val value=1}
                    {foreach $cache['detail']['value'] as $key }
                        <tr>
                            <td>{$val}</td>
                            <td>{$key['barcode']}</td>
                            <td>{$key['name_unit']}</td>
                            <td  style="width:100px;">
                                <input type="number" id="qty-{$key['id_product']}" value="{$key['qty']}" class="form-control" onkeypress="qtyKeyPress({$key['id_product']},'{base_url('purchase-order/detail/update')}')">
                            </td>
                            <td style="width:130px;" class="text-right">Rp {$key['price']|number_format:2:".":","}</td>
                            <td style="width:130px;" class="text-right">Rp {($key['qty'] * $key['price'])|number_format:2:".":","}</td>
                            <td style="width:130px;" class="text-right">Rp {$key['discount_total']|number_format:2:".":","}</td>
                            <td style="width:130px;" class="text-right">Rp {($key['qty'] * $key['price'] - $key['discount_total'])|number_format:2:".":","}</td>
                            <td style="width:90px;">

                                <div class="table-controls">
                                    <a class="btn btn-link btn-icon btn-xs tip" title="Update Qty" onclick="updateQty({$key['id_product']},'{base_url('purchase-order/detail/update')}')"><i class="icon-pencil3"></i></a>
                                    <a href="{base_url('purchase-order/detail/delete')}/{$key['id_product']}" class="btn btn-link btn-icon btn-xs tip" title="Hapus Data"><i class="icon-remove3"></i></a>
                                </div>
                            </td>
                        </tr>
                        {assign var=val value=$val+1}
                        {assign var=total value=$total+($key['qty'] * $key['price'] - $key['discount_total'])}

                    {/foreach}
                    </tbody>
                </table>
            </div>
        {/if}

        <form action="{base_url('purchase-order/save')}" role="form" method="post" enctype="multipart/form-data">

            <div class="panel-body">

                <div class="row invoice-payment">
                    <div class="col-sm-7">

                    </div>

                    <div class="col-sm-2 text-right">
                        <p><h6>Total:</h6></p>
                    </div>
                    <div class="col-sm-2 text-right">
                        <p><h6><strong>Rp {$total|number_format:2:".":","}</strong></h6></p>

                        <input type="hidden" name="total" value="{$total}" >
                    </div>
                </div>

                <div class="form-group">
                    <div class="row">
                        <div class="col-md-4 {if form_error('discount_price')}has-warning{/if}">
                            <label>Discount:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="discount_price" value="{set_value('discount_price',$cache['value']['discount_price'])}" class="form-control" placeholder="0" >

                            </div>
                            {if form_error('discount_price')}
                                <span class="label label-block label-danger text-left">{form_error('discount_price') }</span>
                            {/if}
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <div class="col-md-4 {if form_error('dpp')}has-warning{/if}">
                            <label>DPP:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="dpp" value="{set_value('dpp',$cache['value']['dpp'])}" class="form-control" placeholder="0" >

                            </div>
                            {if form_error('dpp')}
                                <span class="label label-block label-danger text-left">{form_error('dpp') }</span>
                            {/if}
                        </div>
                        <div class="col-md-4 {if form_error('ppn')}has-warning{/if}">
                            <label>PPN:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="ppn" value="{set_value('ppn',$cache['value']['ppn'])}" class="form-control" placeholder="0" >

                            </div>
                            {if form_error('ppn')}
                                <span class="label label-block label-danger text-left">{form_error('ppn') }</span>
                            {/if}
                        </div>
                        <div class="col-md-4 {if form_error('grand_total')}has-warning{/if}">
                            <label>Grand Total:</label>
                            <div class="input-group">
                                <span class="input-group-addon">Rp</span>
                                <input type="text" name="grand_total" value="{set_value('grand_total',$cache['value']['grand_total'])}" class="form-control" placeholder="0">

                            </div>
                            {if form_error('grand_total')}
                                <span class="label label-block label-danger text-left">{form_error('grand_total') }</span>
                            {/if}
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="row">
                        <div class="col-md-4">
                            <label>Upload screenshot:</label>
                            <input type="file" name="file" class="styled form-control" id="report-screenshot">
                            <span class="help-block">Accepted formats: gif, png, jpg. Max file size 2Mb</span>
                        </div>
                    </div>
                </div>
                <div class="form-actions text-right">
                    <button type="submit" name="save" value="Save" class="btn btn-success"><i class="icon-checkmark"></i> Process</button>
                    {*<button type="button" name="print" class="btn btn-default"><i class="icon-print2"></i> Print</button>*}
                </div>
            </div><!-- /panel body -->
        </form>

            {*<div class="panel-body">*}
                {*<h6>Notes &amp; Information:</h6>*}
                {*Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.*}
            {*</div>*}
        {*</div><!-- /default panel -->*}
{/block}