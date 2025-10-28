import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/product_model.dart';
import 'package:get/get.dart';

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtr;
  late final TextEditingController _skuCtr;
  late final TextEditingController _priceCtr;
  late final TextEditingController _stockCtr;

  @override
  void initState() {
    super.initState();
    _nameCtr = TextEditingController(text: widget.product?.name ?? '');
    _skuCtr = TextEditingController(text: widget.product?.sku ?? '');
    _priceCtr = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockCtr = TextEditingController(
      text: widget.product?.stock.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _skuCtr.dispose();
    _priceCtr.dispose();
    _stockCtr.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final uuid = Get.find<Uuid>();
    final id = widget.product?.id ?? uuid.v4();
    final p = ProductModel(
      id: id,
      name: _nameCtr.text.trim(),
      sku: _skuCtr.text.trim().isEmpty ? null : _skuCtr.text.trim(),
      price: double.tryParse(_priceCtr.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockCtr.text.trim()) ?? 0,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    Navigator.of(context).pop(p);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtr,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Tên không được để trống'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skuCtr,
                decoration: const InputDecoration(labelText: 'SKU (tuỳ chọn)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceCtr,
                decoration: const InputDecoration(labelText: 'Giá (VNĐ)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n < 0) return 'Giá không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockCtr,
                decoration: const InputDecoration(
                  labelText: 'Tồn kho (số lượng)',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 0) return 'Số lượng không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
