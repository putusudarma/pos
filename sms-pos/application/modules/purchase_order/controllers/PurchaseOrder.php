<?php
/**
 * Created by PhpStorm.
 * User: Awalin Yudhana
 * Date: 16/04/2015
 * Time: 16:37
 */

defined('BASEPATH') OR exit('No direct script access allowed');

class PurchaseOrder extends MX_Controller
{
    protected $id_staff;

    public function __construct()
    {
        parent::__construct();
        $this->id_staff = $this->config->item('id_staff');
        $this->load->model('product/ModProduct', 'ModProduct');
        $this->load->library('cart',
            array(
                'cache_path' => 'PURCHASE_ORDER',
                'cache_file' => $this->id_staff,
                'primary_table' => 'purchase_order',
                'foreign_table' => 'purchase_order_detail'
            ));
    }

    public function index()
    {
        if ($this->cart->primary_data_exists()) {
            $this->insertPOD();
            return false;
        }

        if ($this->input->post()) {
            if ($this->form_validation->run('po') == TRUE) {
                $this->cart->primary_data(array(
                    'invoice_number' => $this->input->post('invoice_number'),
                    'id_principal' => $this->input->post('id_principal'),
                    'id_staff' => $this->id_staff,
                    'date' => $this->input->post('date'),
                    'due_date' => $this->input->post('due_date')

                ));
                redirect('purchase-order/detail');
            }
        }

        $principal = array('' => '');
        foreach ($this->db->get('principal')->result() as $object) {
            $principal[$object->id_principal] = $object->name;
        }
        $data['principals'] = $principal;
        $this->parser->parse("po.tpl", $data);
    }

    public function insertPOD()
    {
        if (!$this->cart->primary_data_exists()) {
            redirect('purchase-order');
            return false;
        }

        $data['error'] = $this->session->flashdata('error') != null ? $this->session->flashdata('error') : null;
        if ($this->input->post()) {
            if ($this->form_validation->run('po_detail') == TRUE) {
                $data_value = array(
                    'id_product' => $this->input->post('id_product'),
                    'name' => $this->input->post('name'),
                    'barcode' => $this->input->post('barcode'),
                    'unit' => $this->input->post('unit'),
                    'value' => $this->input->post('value'),
                    'brand' => $this->input->post('brand'),
                    'qty' => $this->input->post('qty'),
                    'price' => $this->input->post('price'),
                    'discount_total' => $this->input->post('discount_total') != null ?
                        $this->input->post('discount_total') : 0,
                    'status' => 0
                );

                $this->cart->add_item($this->input->post('id_product'), $data_value);
                redirect('purchase-order/detail');
            }
        }

        $product_storage = $this->ModProduct->get();

        $data['items'] = $this->cart->list_item($product_storage, 'id_product')->result_array_item();
        $cache = $this->cart->array_cache();
        $data['principal'] = $this->db->get_where('principal',
            array('id_principal' => $cache['value']['id_principal']))->row();
        $data['cache'] = $cache;
        $data['product_storage'] = $product_storage;

        $this->parser->parse("po_detail.tpl", $data);
    }

    public function deletePOD($id_product)
    {
        if (!$this->cart->primary_data_exists()) {
            redirect('purchase-order');
            return false;
        }
        if(!$this->cart->delete_item($id_product))
            $this->session->set_flashdata('error',$this->cart->getError());
        redirect('purchase-order/detail');
    }

    public function updatePOD($id_product, $qty)
    {
        if (!$this->cart->primary_data_exists()) {
            redirect('purchase-order');
            return false;
        }

        if(!$this->cart->update_item($id_product, ['qty'=>$qty]))
            $this->session->set_flashdata('error',$this->cart->getError());
        redirect('purchase-order/detail');
    }

    public function resetPO()
    {
        if(!$this->cart->delete_record())
        redirect('purchase-order');
    }

    public function savePO()
    {
        if (!$this->cart->primary_data_exists()) {
            redirect('purchase-order');
            return false;
        }

        if ($this->input->post()) {
            if ($this->form_validation->run('po_save') == TRUE) {
                $scan = "default.jpg";

                if (isset($_FILES['file']['size']) && ($_FILES['file']['size'] > 0)) {
                    $config['upload_path'] = './upload/po';
                    $config['allowed_types'] = 'gif|jpg|png';
                    $config['max_size'] = '2048';
                    $config['max_width'] = '1024';
                    $config['max_height'] = '768';
                    $config['encrypt_name'] = true;

                    $this->load->library('upload', $config);

                    if (!$this->upload->do_upload('file')) {

                        $this->session->set_flashdata('error', $this->upload->display_errors('<small class="error" > ', '</small>'));
                        redirect('purchase-order/detail');
                        return false;
                    }
                    $file = $this->upload->data();
                    $scan = base_url() . "/upload/po" . $file['file_name'];
                }


                if($id_po =$this->cart->primary_data(array(
                    'total' => $this->input->post('total'),
                    'discount_price' => $this->input->post('discount_price'),
                    'dpp' => $this->input->post('dpp'),
                    'ppn' => $this->input->post('ppn'),
                    'grand_total' => $this->input->post('grand_total'),
                    'file' => $scan

                ))->save()){
                    redirect('purchase-order/invoice/' . $id_po);
                }
                $this->session->set_flashdata('error', "transaction error");
            }
        }
        $this->insertPOD();
    }

}