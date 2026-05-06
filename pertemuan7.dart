import 'package:flutter/material.dart';

class RadioButtonPage extends StatefulWidget {
  const RadioButtonPage({super.key});

  @override
  State<RadioButtonPage> createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();

  String? _selectedGender;
  String? _selectedJob;
  String? _selectedWorkType;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _jobOptions = [
    {'value': 'Admin', 'icon': Icons.support_agent, 'color': Colors.blue},
    {'value': 'Guru', 'icon': Icons.school, 'color': Colors.purple},
    {'value': 'Programmer', 'icon': Icons.code, 'color': Colors.blueAccent},
    {'value': 'Pengusaha', 'icon': Icons.business, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> _workTypeOptions = [
    {'value': 'Full Time'},
    {'value': 'Part Time'},
    {'value': 'Freelance'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _namaController.dispose();
    _umurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Radio Button"),
        backgroundColor: Colors.teal,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// ================= DATA DIRI =================
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: "Nama"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _umurController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Umur"),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Umur wajib diisi";
                    int? umur = int.tryParse(v);
                    if (umur == null || umur < 17) return "Minimal umur 17";
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                /// ================= GENDER =================
                FormField<String>(
                  validator: (v) =>
                      v == null ? "Pilih jenis kelamin" : null,
                  builder: (state) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Laki-laki"),
                                value: "Laki-laki",
                                groupValue: _selectedGender,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedGender = val;
                                    state.didChange(val);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("Perempuan"),
                                value: "Perempuan",
                                groupValue: _selectedGender,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedGender = val;
                                    state.didChange(val);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Text(state.errorText!,
                              style: const TextStyle(color: Colors.red)),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                /// ================= PEKERJAAN =================
                FormField<String>(
                  validator: (v) =>
                      v == null ? "Pilih pekerjaan" : null,
                  builder: (state) {
                    return Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: _jobOptions.map((job) {
                            return ChoiceChip(
                              label: Text(job['value']),
                              selected: _selectedJob == job['value'],
                              onSelected: (selected) {
                                setState(() {
                                  _selectedJob =
                                      selected ? job['value'] : null;
                                  state.didChange(_selectedJob);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        if (state.hasError)
                          Text(state.errorText!,
                              style: const TextStyle(color: Colors.red)),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                /// ================= TIPE PEKERJAAN =================
                FormField<String>(
                  validator: (v) =>
                      v == null ? "Pilih tipe kerja" : null,
                  builder: (state) {
                    return Column(
                      children: [
                        ..._workTypeOptions.map((work) {
                          return RadioListTile(
                            title: Text(work['value']),
                            value: work['value'],
                            groupValue: _selectedWorkType,
                            onChanged: (val) {
                              setState(() {
                                _selectedWorkType = val;
                                state.didChange(val);
                              });
                            },
                          );
                        }),
                        if (state.hasError)
                          Text(state.errorText!,
                              style: const TextStyle(color: Colors.red)),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// ================= BUTTON =================
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Data"),
          content: Text(
              "Nama: ${_namaController.text}\nUmur: ${_umurController.text}\nGender: $_selectedGender\nPekerjaan: $_selectedJob\nTipe: $_selectedWorkType"),
        ),
      );
    }
  }
}
