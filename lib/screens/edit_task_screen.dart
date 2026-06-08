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
/// Edit Task Screen
/// ──────────────────────────────────────────────
///
/// Pre-filled form for editing an existing task.
/// Same layout as AddTaskScreen but with existing values
/// and an "Update Task" button.
class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late int _selectedPriority;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing task data
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.dueDate;
    _selectedPriority = widget.task.priority;
  }

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
          'Edit Task',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Delete button in app bar
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.priorityHigh,
            ),
            onPressed: () => _confirmDelete(context),
          ),
        ],
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
                hintText: 'Task title',
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
            GestureDetector(
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
                .slideY(begin: 0.1, end: 0),

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

            // ── Update Button ──
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Update Task',
                icon: Icons.save_rounded,
                onPressed: _updateTask,
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

  /// Validate and update the task
  void _updateTask() {
    if (!_formKey.currentState!.validate()) return;

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _selectedDate,
      priority: _selectedPriority,
    );

    Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\"${updatedTask.title}\" updated! ✨'),
        backgroundColor: AppColors.lavender,
      ),
    );

    Navigator.pop(context);
  }

  /// Confirm deletion with a dialog
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        title: Text(
          'Delete Task',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.task.title}"?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(widget.task.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to home
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: AppColors.priorityHigh,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
