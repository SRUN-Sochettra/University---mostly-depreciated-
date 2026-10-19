import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  String get initials {
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
    final address = user.address;

    return _GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('User Detail')),
        body: ListView(
          padding: AppTheme.screenPadding,
          children: [
            _ProfileCard(
              initials: initials,
              name: user.fullName,
              username: user.username,
              email: user.email,
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Contact',
              icon: Icons.contact_mail_rounded,
              children: [
                _InfoRow(label: 'Email', value: user.email, icon: Icons.mail_outline_rounded),
                _InfoRow(label: 'Phone', value: user.phone, icon: Icons.phone_rounded),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Address',
              icon: Icons.location_on_rounded,
              children: [
                _InfoRow(label: 'City', value: address.city, icon: Icons.location_city_rounded),
                _InfoRow(label: 'Street', value: address.street, icon: Icons.route_rounded),
                _InfoRow(label: 'Number', value: address.number.toString(), icon: Icons.home_rounded),
                _InfoRow(label: 'Zip Code', value: address.zipcode, icon: Icons.markunread_mailbox_rounded),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Geo Location',
              icon: Icons.map_rounded,
              children: [
                _InfoRow(label: 'Latitude', value: address.geolocation.lat, icon: Icons.my_location_rounded),
                _InfoRow(label: 'Longitude', value: address.geolocation.long, icon: Icons.explore_rounded),
              ],
            ),
          ],
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
          colors: [context.colors.backgroundTop, context.colors.backgroundBottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -80, left: -80, child: _Orb(size: 230, color: context.colors.orbOne)),
          Positioned(top: 150, right: -90, child: _Orb(size: 240, color: context.colors.orbTwo)),
          Positioned(bottom: -110, left: 40, child: _Orb(size: 240, color: context.colors.orbThree)),
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
          boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 20)],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String initials;
  final String name;
  final String username;
  final String email;

  const _ProfileCard({
    required this.initials,
    required this.name,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      radius: AppTheme.radiusXl,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _LargeGlassAvatar(initials: initials),
          const SizedBox(height: 18),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTheme.displayTitle(context).copyWith(fontSize: 29, height: 1.05),
          ),
          const SizedBox(height: 8),
          Text('@$username', style: AppTheme.handle(context)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail_outline_rounded, color: context.colors.accent, size: 17),
              const SizedBox(width: 8),
              Flexible(
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
      ),
    );
  }
}

class _LargeGlassAvatar extends StatelessWidget {
  final String initials;

  const _LargeGlassAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.accent.withValues(alpha: 0.14),
        border: Border.all(color: context.colors.accent.withValues(alpha: 0.5), width: 3),
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
                  blurRadius: 12,
                  offset: const Offset(4, 5),
                ),
                BoxShadow(
                  color: context.colors.highlight.withValues(alpha: 0.75),
                  blurRadius: 8,
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
                    context.colors.innerShadow.withValues(alpha: 0.3),
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
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      radius: AppTheme.radiusLg,
      padding: AppTheme.cardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.colors.accentSoft.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(icon, color: context.colors.accent, size: 21),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTheme.cardTitle(context)),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final double radius;
  final EdgeInsets padding;
  final Widget child;

  const _GlassPanel({
    required this.radius,
    required this.padding,
    required this.child,
  });

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppTheme.blur, sigmaY: AppTheme.blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: context.colors.glassStrong,
              borderRadius: BorderRadius.circular(radius - 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.colors.accent),
          const SizedBox(width: 10),
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: context.colors.ink,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
