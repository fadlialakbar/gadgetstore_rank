// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../domain/entities/review.dart';
// import '../providers/review_provider.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:go_router/go_router.dart';

// class ReviewerDetailScreen extends StatefulWidget {
//   final String reviewerId;
//   final String reviewerName;
//   final String reviewerImage;
//   final bool isGold;

//   const ReviewerDetailScreen({
//     super.key,
//     required this.reviewerId,
//     required this.reviewerName,
//     required this.reviewerImage,
//     this.isGold = false,
//   });

//   @override
//   State<ReviewerDetailScreen> createState() => _ReviewerDetailScreenState();
// }

// class _ReviewerDetailScreenState extends State<ReviewerDetailScreen> {
//   String? _statusMessage;
//   String? _joinDate;
//   int _reviewCount = 0;
//   int _rank = 0;

//   // Hardcoded stats for detail enhancement
//   final Map<String, double> _performanceStats = {
//     'Photo Quality': 4.8,
//     'Detail Level': 4.6,
//     'Helpfulness': 4.9,
//     'Consistency': 4.7,
//   };

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadReviewerData();
//     });
//   }

//   Future<void> _loadReviewerData() async {
//     try {
//       final String jsonData = await rootBundle.loadString(
//         'assets/data/users.json',
//       );
//       final List<dynamic> usersData = json.decode(jsonData);

//       for (final userData in usersData) {
//         if (userData['id'] == widget.reviewerId) {
//           setState(() {
//             _statusMessage = userData['statusMessage'];
//             _reviewCount = userData['reviewCount'] ?? 0;
//             _rank = userData['rank'] ?? 0;
//             if (userData['joinDate'] != null) {
//               final DateTime date = DateTime.parse(userData['joinDate']);
//               _joinDate = '${date.month}/${date.year}';
//             }
//           });
//           break;
//         }
//       }
//     } catch (e) {
//       print('Error loading user status message: $e');
//     }

//     final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
//     await reviewProvider.fetchReviewsByUser(widget.reviewerId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.reviewerName),
//         elevation: 0,
//         actions: [
//           if (widget.isGold)
//             Padding(
//               padding: const EdgeInsets.only(right: 16),
//               child: SvgPicture.asset(
//                 'assets/icons/crown.svg',
//                 width: 24,
//                 height: 24,
//                 colorFilter: const ColorFilter.mode(
//                   Colors.amber,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Consumer<ReviewProvider>(
//         builder: (context, reviewProvider, child) {
//           if (reviewProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (reviewProvider.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error loading reviewer data: ${reviewProvider.errorMessage}',
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.error,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _loadReviewerData,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // Use the reviews loaded specifically for this user
//           final reviewsByUser = reviewProvider.reviewsByUser;

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildReviewerProfile(),

//                 _buildReviewerStats(),

//                 const SizedBox(height: 16),

//                 // Featured Review Photos Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     'Featured Review Photos',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 _buildReviewPhotos(),

//                 const SizedBox(height: 24),

//                 // Reviews Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '${l10n.reviews} ($_reviewCount)',
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       Text(
//                         'Sort by: Recent',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 if (reviewsByUser.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Center(
//                       child: Text(
//                         l10n.errorLoadingData,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                     ),
//                   )
//                 else
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: reviewsByUser.length,
//                     itemBuilder: (context, index) {
//                       return _buildReviewItem(context, reviewsByUser[index]);
//                     },
//                   ),

//                 const SizedBox(height: 32),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildReviewerProfile() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       color: Theme.of(context).colorScheme.surface,
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: AssetImage(widget.reviewerImage),
//               ),
//               if (widget.isGold || _rank == 1)
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.amber,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 4,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                     child: SvgPicture.asset(
//                       'assets/icons/crown.svg',
//                       width: 16,
//                       height: 16,
//                       colorFilter: const ColorFilter.mode(
//                         Colors.white,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             widget.reviewerName,
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           if (_statusMessage != null) ...[
//             const SizedBox(height: 8),
//             Text(
//               _statusMessage!,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontStyle: FontStyle.italic,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//           const SizedBox(height: 16),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildProfileStat('Rank', '#$_rank', Icons.leaderboard_outlined),
//               const SizedBox(width: 24),
//               _buildProfileStat(
//                 'Reviews',
//                 '$_reviewCount',
//                 Icons.rate_review_outlined,
//               ),
//               const SizedBox(width: 24),
//               if (_joinDate != null)
//                 _buildProfileStat(
//                   'Joined',
//                   _joinDate!,
//                   Icons.calendar_today_outlined,
//                 ),
//             ],
//           ),

//           const SizedBox(height: 16),
//           if (widget.isGold || _rank == 1)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.amber.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.amber.shade300),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/icons/crown.svg',
//                     width: 20,
//                     height: 20,
//                     colorFilter: const ColorFilter.mode(
//                       Colors.amber,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Top Ranked Reviewer',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.amber,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileStat(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
//           size: 22,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildReviewerStats() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Review Performance',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 16),
//           ..._performanceStats.entries.map((entry) {
//             final percent = (entry.value / 5) * 100;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(entry.key),
//                       Text(
//                         entry.value.toString(),
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   LinearProgressIndicator(
//                     value: entry.value / 5,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       percent > 90
//                           ? Colors.green
//                           : percent > 75
//                           ? Colors.blue
//                           : Colors.orange,
//                     ),
//                     borderRadius: BorderRadius.circular(4),
//                     minHeight: 8,
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),

//           const SizedBox(height: 8),

//           Center(
//             child: Text(
//               '★ Based on the quality of published reviews',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReviewPhotos() {
//     // Hardcoded images for the review photos
//     final List<String> reviewPhotoAssets = [
//       'assets/images/product_reviews/raizen_review_1.png',
//       'assets/images/product_reviews/raizen_review_2.png',
//       'assets/images/product_reviews/raizen_review_3.png',
//     ];

//     return Container(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: reviewPhotoAssets.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: () {
//                 // Show full-screen image view
//                 _showFullScreenImage(context, reviewPhotoAssets[index]);
//               },
//               child: Container(
//                 width: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     reviewPhotoAssets[index],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showFullScreenImage(BuildContext context, String imageAsset) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => Dialog(
//             insetPadding: EdgeInsets.zero,
//             backgroundColor: Colors.transparent,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     color: Colors.black.withOpacity(0.7),
//                     child: InteractiveViewer(
//                       minScale: 0.5,
//                       maxScale: 3.0,
//                       child: Center(
//                         child: Image.asset(imageAsset, fit: BoxFit.contain),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 40,
//                   right: 20,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   Widget _buildReviewItem(BuildContext context, Review review) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               onTap: () {
//                 // Navigate to product detail
//                 context.push('/product/${review.productId}');
//               },
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           review.productName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           '${review.datePosted.day}/${review.datePosted.month}/${review.datePosted.year}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade200),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Image.asset(
//                       review.productImageUrl,
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: List.generate(
//                 5,
//                 (index) => Icon(
//                   index < review.rating.floor()
//                       ? Icons.star
//                       : index < review.rating
//                       ? Icons.star_half
//                       : Icons.star_border,
//                   size: 18,
//                   color: Colors.amber,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               review.title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(review.content, style: const TextStyle(height: 1.4)),

//             if (review.pros.isNotEmpty || review.cons.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (review.pros.isNotEmpty)
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Pros',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           ...review.pros.map(
//                             (pro) => Padding(
//                               padding: const EdgeInsets.only(bottom: 4),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Icon(
//                                     Icons.add_circle,
//                                     color: Colors.green,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       pro,
//                                       style: const TextStyle(fontSize: 13),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (review.pros.isNotEmpty && review.cons.isNotEmpty)
//                     const SizedBox(width: 16),
//                   if (review.cons.isNotEmpty)
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Cons',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           ...review.cons.map(
//                             (con) => Padding(
//                               padding: const EdgeInsets.only(bottom: 4),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Icon(
//                                     Icons.remove_circle,
//                                     color: Colors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Text(
//                                       con,
//                                       style: const TextStyle(fontSize: 13),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ],

//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.thumb_up_outlined,
//                       size: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Helpful (${review.helpfulCount})',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.bookmark_border,
//                       size: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Save',
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
