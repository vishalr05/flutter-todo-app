import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/stats_card.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

/// ──────────────────────────────────────────────
/// Home Screen
/// ──────────────────────────────────────────────
///
/// The main screen of the app containing:
///   - Greeting with user name
///   - Dark mode toggle
///   - Task statistics card
///   - Search bar
///   - Category filter chips
///   - Animated task list
///   - FAB to add new tasks
///   - Daily motivational quote
///   - Empty state when no tasks
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final tasks = taskProvider.filteredTasks;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──
            SliverToBoxAdapter(
              child: _buildHeader(context, themeProvider),
            ),

            // ── Stats Card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: StatsCard(
                  total: taskProvider.totalTasks,
                  completed: taskProvider.completedTasks,
                  pending: taskProvider.pendingTasks,
                  completionPercentage: taskProvider.completionPercentage,
                ),
              ),
            ),

            // ── Search Bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SearchBarWidget(
                  controller: _searchController,
                  onChanged: (query) => taskProvider.setSearchQuery(query),
                  onClear: () {
                    taskProvider.clearSearch();
                    setState(() {});
                  },
                ),
              ),
            ),

            // ── Filter Chips ──
            SliverToBoxAdapter(
              child: _buildFilterChips(context, taskProvider),
            ),

            // ── Task List OR Empty State ──
            if (tasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  message: taskProvider.searchQuery.isNotEmpty
                      ? 'No matching tasks'
                      : taskProvider.filter != TaskFilter.all
                          ? 'No ${_getFilterLabel(taskProvider.filter).toLowerCase()} tasks'
                          : 'No tasks yet!',
                  subtitle: taskProvider.searchQuery.isNotEmpty
                      ? 'Try a different search term'
                      : 'Tap the + button to add your first task',
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Add daily quote at the bottom
                    if (index == tasks.length) {
                      return _buildDailyQuote(isDark);
                    }

                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      animationIndex: index,
                      onToggleComplete: () {
                        taskProvider.toggleComplete(task.id);
                      },
                      onTap: () => _navigateToEdit(context, task),
                      onDelete: () => _deleteTask(context, taskProvider, task),
                    );
                  },
                  childCount: tasks.length + 1, // +1 for daily quote
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),

      // ── FAB ──
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAdd(context),
        child: const Icon(Icons.add_rounded, size: 28),
      )
          .animate()
          .fadeIn(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 500),
          )
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
          ),
    );
  }

  /// Header with greeting and dark mode toggle
  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingMedium,
        AppSizes.paddingMedium,
        AppSizes.paddingMedium,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getGreeting()} 👋',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hello, Vishal',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textDark : AppColors.textPrimary,
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 500))
              .slideX(
                begin: -0.1,
                end: 0,
                duration: const Duration(milliseconds: 500),
              ),

          // Dark mode toggle button
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardDark
                  : AppColors.lavender.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                  color: isDark ? AppColors.coral : AppColors.lavender,
                  size: 22,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 200),
              ),
        ],
      ),
    );
  }

  /// Build the filter chips row
  Widget _buildFilterChips(BuildContext context, TaskProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: 8,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CategoryChip(
              label: 'All',
              icon: Icons.list_rounded,
              isSelected: provider.filter == TaskFilter.all,
              onTap: () => provider.setFilter(TaskFilter.all),
            ),
            const SizedBox(width: 8),
            CategoryChip(
              label: 'Completed',
              icon: Icons.check_circle_outline_rounded,
              isSelected: provider.filter == TaskFilter.completed,
              onTap: () => provider.setFilter(TaskFilter.completed),
            ),
            const SizedBox(width: 8),
            CategoryChip(
              label: 'Pending',
              icon: Icons.pending_outlined,
              isSelected: provider.filter == TaskFilter.pending,
              onTap: () => provider.setFilter(TaskFilter.pending),
            ),
            const SizedBox(width: 8),
            CategoryChip(
              label: 'High Priority',
              icon: Icons.flag_rounded,
              isSelected: provider.filter == TaskFilter.highPriority,
              onTap: () => provider.setFilter(TaskFilter.highPriority),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 200),
        );
  }

  /// Daily motivational quote at the bottom of the list
  Widget _buildDailyQuote(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingMedium),
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.lavender.withValues(alpha: 0.1),
                  AppColors.coral.withValues(alpha: 0.1),
                ]
              : [
                  AppColors.lavender.withValues(alpha: 0.05),
                  AppColors.coral.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(
          color: isDark
              ? AppColors.lavender.withValues(alpha: 0.15)
              : AppColors.lavender.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              getDailyQuote(),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey.shade400 : AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 500));
  }

  // ── Navigation ───────────────────────────────

  void _navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddTaskScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeOutCubic),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, Task task) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditTaskScreen(task: task),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _deleteTask(
    BuildContext context,
    TaskProvider provider,
    Task task,
  ) {
    provider.deleteTask(task.id);

    // Show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('\"${task.title}\" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.coral,
          onPressed: () {
            provider.addTask(task);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getFilterLabel(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.highPriority:
        return 'High Priority';
      default:
        return 'All';
    }
  }
}
