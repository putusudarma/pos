<?php
/**
 * Created by PhpStorm.
 * User: Awalin Yudhana
 * Date: 17/04/2015
 * Time: 17:01
 */
$config = array(
    'po' => array(
        array(
            'field' => 'id_principal',
            'label' => 'Principal',
            'rules' => 'required'
        ),
        array(
            'field' => 'invoice_number',
            'label' => 'Invoice Number',
            'rules' => 'trim|alpha_dash'
        ),
        array(
            'field' => 'date',
            'label' => 'Order Date',
            'rules' => 'required'
        ),
        array(
            'field' => 'due_date',
            'label' => 'Due Date',
            'rules' => 'required'
        ),
    ),
    'po_detail' => array(
        array(
            'field' => 'id_product',
            'label' => 'Product',
            'rules' => 'required|integer'
        ),
        array(
            'field' => 'qty',
            'label' => 'QTY Number',
            'rules' => 'required|integer'
        ),
        array(
            'field' => 'price',
            'label' => 'Price',
            'rules' => 'required|numeric'
        ),
        array(
            'field' => 'discount_total',
            'label' => 'Discount',
            'rules' => 'numeric'
        ),
    ),
    'po_save' => array(
        array(
            'field' => 'total',
            'label' => 'Total',
            'rules' => 'required|numeric'
        ),
        array(
            'field' => 'discount_price',
            'label' => 'Discount',
            'rules' => 'numeric'
        ),
        array(
            'field' => 'dpp',
            'label' => 'DPP',
            'rules' => 'required|numeric'
        ),
        array(
            'field' => 'ppn',
            'label' => 'PPN',
            'rules' => 'numeric'
        ),
        array(
            'field' => 'grand_total',
            'label' => 'Grand Total',
            'rules' => 'required|numeric'
        ),
    )
);