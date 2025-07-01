import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:byewall3/ui/components/custom_list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:byewall3/break_services/services_helper.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:byewall3/ui/components/service_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ServiceSettingsView extends StatefulWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

  @override
  State<ServiceSettingsView> createState() => ServiceSettingsViewState();
}

class ServiceSettingsViewState extends State<ServiceSettingsView> {
  void openEditDialog(BuildContext context, ServicesModel service) {
    showDialog(
      context: context,
      builder: (context) {
        return ServiceDialog(
          initialService: service, // Passa o serviço para edição
        );
      },
    );
  }

  Stack _buildServiceIcon(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 2,
          child: Icon(
            Icons.circle,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        Transform.scale(
          scale: 1.1,
          child: Icon(Icons.web, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  int _getBorderType(int index, int totalServices) {
    if (totalServices == 1) {
      return 3; // all borders para item único
    } else if (index == 0) {
      return 1; // top border para primeiro item
    } else if (index == totalServices - 1) {
      return 2; // bottom border para último item
    } else {
      return 0; // no border para itens do meio
    }
  }

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ServicesModel>('services').listenable(),
      builder: (context, Box<ServicesModel> box, _) {
        final services = box.values.toList();

        return Scaffold(
          body: SlidableAutoCloseBehavior(
            child: Stack(
              children: [
                CustomScrollView(
                  key: const PageStorageKey('serviceSettings'),
                  controller: widget.controller,
                  slivers: [
                    customSliverAppBar.buildSliverAppBar('services'),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children:
                              services.asMap().entries.map((entry) {
                                final index = entry.key;
                                final service = entry.value;
                                final borderType = _getBorderType(index, services.length);

                                return Column(
                                  children: [
                                    // Adiciona espaçamento antes do item (exceto para o primeiro)
                                    if (index > 0) const SizedBox(height: 2),

                                    Stack(
                                      children: [
                                        // Fundo vermelho que se estende do centro até a direita
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          width: 120, // Largura fixa para cobrir área do slide
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.error,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                  borderType == 1 || borderType == 3 ? 20 : 0,
                                                ),
                                                bottomRight: Radius.circular(
                                                  borderType == 2 || borderType == 3 ? 20 : 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Slidable com custom_list_tiles
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                              borderType == 1 || borderType == 3 ? 20 : 0,
                                            ),
                                            topRight: Radius.circular(
                                              borderType == 1 || borderType == 3 ? 20 : 0,
                                            ),
                                            bottomLeft: Radius.circular(
                                              borderType == 2 || borderType == 3 ? 20 : 0,
                                            ),
                                            bottomRight: Radius.circular(
                                              borderType == 2 || borderType == 3 ? 20 : 0,
                                            ),
                                          ),
                                          child: Slidable(
                                            key: Key(service.key.toString()),
                                            groupTag: 'services',
                                            endActionPane: ActionPane(
                                              extentRatio: 0.15,
                                              motion: const ScrollMotion(),
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.error,
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        ServicesHelper.removeService(service.key);
                                                      },
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.delete_forever_outlined,
                                                          size: 32,
                                                          color:
                                                              Theme.of(context).colorScheme.onError,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            child: SettingsTiles(
                                              border: borderType,
                                              title: service.serviceName,
                                              subtitle: service.serviceUrl,
                                              lIcon: _buildServiceIcon(context),
                                              checkboxEnable: true,
                                              checkboxValue: service.isEnable,
                                              onCheckboxChanged: (value) {
                                                setState(() {
                                                  service.isEnable = value ?? false;
                                                  service.save();
                                                });
                                              },
                                              onPressed: () {
                                                // Ação quando o tile é pressionado (opcional)
                                              },
                                              onLongPress: () {
                                                openEditDialog(context, service);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),

                    // Espaçamento final
                    SliverToBoxAdapter(child: const SizedBox(height: 120)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
