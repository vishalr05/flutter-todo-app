import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/gradient_button.dart';
import '../widgets/priority_selector.dart';

/// ──────────────────────────────────────────────
/// Add Task Screen
/// ──────────────────────────────────────────────
///
/// Form screen for creating a new task with:
///   - Title (required)
///   - Description (optional)
///   - Due date picker
///   - Priority selector (Low / Medium / High)
///   - Save button with validation
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Task properties
  DateTime _selectedDate = DateTime.now();
  int _selectedPriority = 0; // Low by default

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          children: [
            // ── Title Field ──
            Text(
              'Title',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'What do you need to do?',
                prefixIcon: Icon(Icons.title_rounded, size: 20),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 400))
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // ── Description Field ──
            Text(
              'Description (optional)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Add some details...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.notes_rounded, size: 20),
                ),
                alignLabelWithHint: true,
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 100),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // ── Due Date Picker ──
            Text(
              'Due Date',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildDatePicker(context, isDark),

            const SizedBox(height: 24),

            // ── Priority Selector ──
            Text(
              'Priority',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            PrioritySelector(
              selectedPriority: _selectedPriority,
              onChanged: (priority) {
                setState(() => _selectedPriority = priority);
              },
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 300),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: 40),

            // ── Save Button ──
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Save Task',
                icon: Icons.check_rounded,
                onPressed: _saveTask,
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 400),
                )
                .slideY(
                  begin: 0.2,
                  end: 0,
                  delay: const Duration(milliseconds: 400),
                ),
          ],
        ),
      ),
    );
  }

  /// Date picker with a styled container
  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: AppColors.lavender,
            ),
            const SizedBox(width: 12),
            Text(
              formatDate(_selectedDate),
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: isDark ? Colors.grey.shade500 : AppColors.textLight,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 200),
        )
        .slideY(begin: 0.1, end: 0);
  }

  /// Show the material date picker
  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.lavender,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  /// Validate form and save the task
  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: generateId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _selectedDate,
      priority: _selectedPriority,
      createdAt: DateTime.now(),
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\"${task.title}\" added! ✨'),
        backgroundColor: AppColors.lavender,
      ),
    );

    Navigator.pop(context);
  }
}
