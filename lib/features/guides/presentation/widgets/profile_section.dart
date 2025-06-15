import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/guide_form_providers.dart';
import '../../data/guide_form_models.dart';

class ProfileSection extends ConsumerStatefulWidget {
  const ProfileSection({super.key});

  @override
  ConsumerState<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends ConsumerState<ProfileSection> {
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
  }

  void _updateController(GuideFormState formState) {
    final bioText = formState.bio ?? '';
    if (_bioController.text != bioText) {
      _bioController.text = bioText;
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(guideFormProvider);

    // 상태 변경을 감지하여 컨트롤러 업데이트
    ref.listen<GuideFormState>(guideFormProvider, (previous, next) {
      if (previous != next) {
        _updateController(next);
      }
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지 섹션
          _buildProfileImageSection(formState.profileImageUrl),
          const SizedBox(height: 32),

          // 자기소개 섹션
          _buildBioSection(formState.bio),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(String? profileImageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '프로필 이미지',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '가이드의 프로필 이미지를 업로드해주세요. (선택사항)',
          style: TextStyle(fontSize: 14, color: Color(0xFF6C757D), height: 1.4),
        ),
        const SizedBox(height: 16),

        // 이미지 업로드 영역
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE9ECEF),
              style: BorderStyle.solid,
            ),
          ),
          child:
              profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? _buildImagePreview(profileImageUrl)
                  : _buildImageUploadPlaceholder(),
        ),

        const SizedBox(height: 12),

        // 업로드 버튼들
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.photo_library, size: 18),
              label: const Text('이미지 선택'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF495057),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (profileImageUrl != null && profileImageUrl.isNotEmpty)
              OutlinedButton.icon(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('삭제'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC3545),
                  side: const BorderSide(color: Color(0xFFDC3545)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // 이미지 업로드 안내사항
        const Text(
          '• 권장 크기: 400x400px 이상\n• 지원 형식: JPG, PNG (최대 5MB)\n• 얼굴이 잘 보이는 정면 사진을 권장합니다',
          style: TextStyle(fontSize: 12, color: Color(0xFF6C757D), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // 이미지 로드 실패 시 처리
                },
              ),
            ),
          ),

          // 어두운 오버레이
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
              ),
            ),
          ),

          // 미리보기 텍스트
          const Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.photo, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '프로필 이미지 미리보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE9ECEF),
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Icon(Icons.person, size: 32, color: Color(0xFF6C757D)),
        ),
        const SizedBox(height: 16),
        const Text(
          '프로필 이미지가 없습니다',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C757D),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '아래 버튼을 눌러 이미지를 선택해주세요',
          style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
        ),
      ],
    );
  }

  Widget _buildBioSection(String? bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '자기소개',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '가이드의 경력, 전문 지식, 성격 등을 소개해주세요. (선택사항)',
          style: TextStyle(fontSize: 14, color: Color(0xFF6C757D), height: 1.4),
        ),
        const SizedBox(height: 16),

        // 자기소개 텍스트 필드
        TextFormField(
          controller: _bioController,
          maxLines: 8,
          maxLength: 500,
          decoration: InputDecoration(
            hintText:
                '예시: 안녕하세요! 5년 경력의 의료 전문 가이드입니다. 성형외과와 피부과 분야에 특히 전문적이며, 한국어, 영어, 중국어로 안내 가능합니다. 고객분들의 안전하고 편안한 의료 여행을 위해 최선을 다하겠습니다.',
            hintStyle: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 14,
              height: 1.4,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCED4DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF495057), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            counterStyle: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 12,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF212529),
            height: 1.4,
          ),
          onChanged: (value) {
            ref
                .read(guideFormProvider.notifier)
                .updateBio(value.isEmpty ? null : value);
          },
        ),

        const SizedBox(height: 12),

        // 자기소개 작성 팁
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    size: 16,
                    color: Color(0xFF495057),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '자기소개 작성 팁',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '• 의료 관련 경력이나 자격증이 있다면 언급해주세요\n• 성격이나 서비스 스타일을 간단히 소개해주세요\n• 고객에게 도움이 될 만한 특별한 경험이 있다면 적어주세요\n• 너무 길지 않게 간결하고 친근하게 작성해주세요',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6C757D),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectImage() {
    // TODO: 이미지 선택 구현
    // 실제로는 image_picker 패키지를 사용해서 이미지를 선택하고
    // Supabase Storage에 업로드한 후 URL을 받아와야 함

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('이미지 선택'),
            content: const Text('이미지 선택 기능은 추후 구현 예정입니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  void _removeImage() {
    ref.read(guideFormProvider.notifier).updateProfileImageUrl(null);
  }
}
