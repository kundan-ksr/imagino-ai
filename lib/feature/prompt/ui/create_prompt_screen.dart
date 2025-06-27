import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prompt_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  TextEditingController controller = TextEditingController();

  final PromptBloc promptBloc = PromptBloc();

  @override
  void initState() {
    promptBloc.add(PromptInitialEvent());
    super.initState();
  }

  Widget buildPromptInput() {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter your prompt",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            cursorColor: Colors.tealAccent,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.tealAccent),
                    borderRadius: BorderRadius.circular(12)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            width: double.maxFinite,
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.blueAccent.shade700)),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    promptBloc.add(PromptEnteredEvent(prompt: controller.text));
                  }
                },
                icon: const Icon(Icons.generating_tokens),
                label: const Text("Generate")),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Generate Images🚀"),
      ),
      body: BlocConsumer<PromptBloc, PromptState>(
        bloc: promptBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PromptGeneratingImageLoadState:
              return const Center(child: CircularProgressIndicator());

            case PromptGeneratingImageErrorState:
              return const Center(child: Text("Something went wrong"));

            case PromptGeneratingImageSuccessState:
              final successState = state as PromptGeneratingImageSuccessState;
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        MemoryImage(successState.uint8list))))),
                    buildPromptInput()
                  ],
                ),
              );

            default:
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        height: MediaQuery.sizeOf(context).height * 0.6,
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/homepage.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildPromptInput()
                ],
              );
          }
        },
      ),
    );
  }
}
