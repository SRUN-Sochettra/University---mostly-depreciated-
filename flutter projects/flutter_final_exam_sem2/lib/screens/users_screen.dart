import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'user_detail_screen.dart';

class UsersScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const UsersScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _userService = UserService();
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _userService.getUsers();
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _usersFuture = _userService.getUsers();
    });

    await _usersFuture;
  }

  String _initialsFor(UserModel user) {
    final first = user.name.firstname.trim();
    final last = user.name.lastname.trim();

    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }

    if (user.username.trim().isNotEmpty) {
      return user.username.trim()[0].toUpperCase();
    }

    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return _GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<List<UserModel>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _LoadingState(onToggleTheme: widget.onToggleTheme);
              }

              if (snapshot.hasError) {
                return _ErrorState(
                  message: snapshot.error.toString(),
                  onRetry: _refreshUsers,
                  onToggleTheme: widget.onToggleTheme,
                );
              }

              final users = snapshot.data ?? [];

              if (users.isEmpty) {
                return _EmptyState(onToggleTheme: widget.onToggleTheme);
              }

              return RefreshIndicator(
                color: context.colors.accent,
                onRefresh: _refreshUsers,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _Header(
                        totalUsers: users.length,
                        onToggleTheme: widget.onToggleTheme,
                      ),
                    ),
                    SliverList.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return _GlassUserCard(
                          user: user,
                          initials: _initialsFor(user),
                          index: index,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDetailScreen(user: user),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GlassBackground extends StatelessWidget {
  final Widget child;

  const _GlassBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.backgroundTop,
            context.colors.backgroundBottom,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: _Orb(size: 230, color: context.colors.orbOne),
          ),
          Positioned(
            top: 150,
            right: -90,
            child: _Orb(size: 240, color: context.colors.orbTwo),
          ),
          Positioned(
            bottom: -110,
            left: 40,
            child: _Orb(size: 240, color: context.colors.orbThree),
          ),
          child,
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;

  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 60, spreadRadius: 20),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int totalUsers;
  final VoidCallback onToggleTheme;

  const _Header({required this.totalUsers, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Users', style: AppTheme.displayTitle(context)),
                const SizedBox(height: 8),
                Text(
                  '$totalUsers users loaded from Fake Store API',
                  style: AppTheme.subtitle(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GlassCircleButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            onTap: onToggleTheme,
          ),
        ],
      ),
    );
  }
}

class _GlassUserCard extends StatelessWidget {
  final UserModel user;
  final String initials;
  final int index;
  final VoidCallback onTap;

  const _GlassUserCard({
    required this.user,
    required this.initials,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: _GradientGlassBorder(
        radius: AppTheme.radiusLg,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppTheme.blur,
              sigmaY: AppTheme.blur,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.glass,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
                    boxShadow: context.glassShadow,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusLg - 1,
                      ),
                      onTap: onTap,
                      child: Padding(
                        padding: AppTheme.cardPadding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _GlassAvatar(initials: initials),
                            const SizedBox(width: 18),
                            Expanded(
                              child: _CardText(
                                name: user.fullName,
                                username: user.username,
                                email: user.email,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _CardActions(rank: index + 1, onTap: onTap),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1,
                  left: 18,
                  right: 18,
                  child: Container(height: 1, color: context.colors.highlight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientGlassBorder extends StatelessWidget {
  final double radius;
  final Widget child;

  const _GradientGlassBorder({required this.radius, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.borderStrong,
            context.colors.border.withValues(alpha: 0.56),
            context.colors.accent.withValues(alpha: 0.18),
          ],
        ),
        boxShadow: context.glassShadow,
      ),
      child: child,
    );
  }
}

class _GlassAvatar extends StatelessWidget {
  final String initials;

  const _GlassAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.highlight,
            context.colors.accent.withValues(alpha: 0.22),
          ],
        ),
        border: Border.all(
          color: context.colors.accent.withValues(alpha: 0.45),
          width: 2.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.accentSoft.withValues(alpha: 0.86),
              border: Border.all(color: context.colors.border),
              boxShadow: [
                BoxShadow(
                  color: context.colors.innerShadow,
                  blurRadius: 10,
                  offset: const Offset(3, 4),
                ),
                BoxShadow(
                  color: context.colors.highlight.withValues(alpha: 0.75),
                  blurRadius: 7,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.42, -0.42),
                  radius: 0.95,
                  colors: [
                    context.colors.highlight.withValues(alpha: 0.55),
                    Colors.transparent,
                    context.colors.innerShadow.withValues(alpha: 0.26),
                  ],
                  stops: const [0, 0.58, 1],
                ),
              ),
            ),
          ),
          Text(
            initials,
            style: TextStyle(
              color: context.colors.accent,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  final String name;
  final String username;
  final String email;

  const _CardText({
    required this.name,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.cardTitle(context),
        ),
        const SizedBox(height: 6),
        Text(
          '@$username',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.handle(context),
        ),
        const SizedBox(height: 9),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 17,
              color: context.colors.accent,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.body(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardActions extends StatelessWidget {
  final int rank;
  final VoidCallback onTap;

  const _CardActions({required this.rank, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: context.colors.gold,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: context.colors.gold.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text('#$rank', style: AppTheme.small(context)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'View Profile',
              style: TextStyle(
                color: context.colors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            _GlassCircleButton(
              tooltip: 'View profile',
              icon: Icons.chevron_right_rounded,
              onTap: onTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCircleButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.glassStrong,
            border: Border.all(color: context.colors.borderStrong),
            boxShadow: context.buttonShadow,
          ),
          child: IconButton(
            tooltip: tooltip,
            padding: EdgeInsets.zero,
            onPressed: onTap,
            icon: Icon(icon, color: context.colors.ink, size: 25),
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _LoadingState({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _Header(totalUsers: 0, onToggleTheme: onToggleTheme),
        for (int i = 0; i < 5; i++) const _SkeletonCard(),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: _GradientGlassBorder(
        radius: AppTheme.radiusLg,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppTheme.blur,
              sigmaY: AppTheme.blur,
            ),
            child: Container(
              padding: AppTheme.cardPadding,
              decoration: BoxDecoration(
                color: context.colors.glass,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.accentSoft.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _skeletonLine(context, width: 150),
                        const SizedBox(height: 10),
                        _skeletonLine(context, width: 95),
                        const SizedBox(height: 10),
                        _skeletonLine(context, width: double.infinity),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _skeletonLine(BuildContext context, {required double width}) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: context.colors.borderStrong.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onToggleTheme;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppTheme.screenPadding,
      children: [
        _Header(totalUsers: 0, onToggleTheme: onToggleTheme),
        const SizedBox(height: 12),
        _GlassMessageCard(
          icon: Icons.wifi_off_rounded,
          title: 'Could not load users',
          message: message,
          iconColor: context.colors.danger,
          action: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const _EmptyState({required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppTheme.screenPadding,
      children: [
        _Header(totalUsers: 0, onToggleTheme: onToggleTheme),
        const SizedBox(height: 12),
        _GlassMessageCard(
          icon: Icons.person_off_rounded,
          title: 'No users found',
          message: 'The API returned an empty user list.',
          iconColor: context.colors.accent,
        ),
      ],
    );
  }
}

class _GlassMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color iconColor;
  final Widget? action;

  const _GlassMessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.iconColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return _GradientGlassBorder(
      radius: AppTheme.radiusXl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppTheme.blur,
            sigmaY: AppTheme.blur,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colors.glassStrong,
              borderRadius: BorderRadius.circular(AppTheme.radiusXl - 1),
            ),
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 46),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTheme.cardTitle(context),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTheme.subtitle(context),
                ),
                if (action != null) ...[const SizedBox(height: 20), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
