import 'dart:convert';

import 'package:http/http.dart' as http;

class _StableHordeBloc {
  List<String> _requestIds = [];

  Future requestDiffusion(
    String prompt,
    double mutationRate,
  ) async {
    /// headers = {
    /// 'Accept': '* / *',
    /// 'Accept-Language': 'en-US,en;q=0.9',
    /// 'Connection': 'keep-alive',
    /// 'apikey': 'rFs6AHt5qy6Ew0QnK8M9XQ',
    /// }
    ///
    /// source_image = requests.get(init_image_url).content
    /// print(len(source_image))
    ///
    /// json_data = {
    /// 'prompt': prompt,
    /// 'params': {
    /// 'steps': 30,
    /// 'n': 1,
    /// 'sampler_name': 'k_euler',
    /// 'width': 512,
    /// 'height': 512,
    /// 'cfg_scale': 7,
    /// 'seed_variation': 1000,
    /// 'seed': '',
    /// 'karras': True,
    /// 'denoising_strength': strength,
    /// 'post_processing': [],
    /// },
    /// 'nsfw': False,
    /// 'censor_nsfw': False,
    /// 'trusted_workers': False,
    /// 'source_processing': 'img2img',
    /// 'source_image': base64.b64encode(source_image).decode('utf-8'),
    /// 'models': [
    /// 'stable_diffusion',
    /// ],
    /// }
    ///
    /// start = time.time()
    /// response = requests.post(
    /// 'https://stablehorde.net/api/v2/generate/async', headers=headers, json=json_data
    /// )

    final headers = {
      'Accept': '* / *',
      'Accept-Language': 'en-US,en;q=0.9',
      'Connection': 'keep-alive',
      'apikey': 'oad7PZBRUgwrpucqgEBgEw',
      "Content-Type": "application/json",
    };

    final json = {
      'prompt': prompt,
      'params': {
        'steps': 30,
        'n': 1,
        'sampler_name': 'k_euler',
        'width': 512,
        'height': 512,
        'cfg_scale': 7,
        'seed_variation': 1000,
        'seed': '',
        'karras': true,
        'denoising_strength': mutationRate,
        'post_processing': [],
      },
      'nsfw': false,
      'censor_nsfw': false,
      'trusted_workers': false,
      'source_processing': 'img2img',
      //'source_image': base64.encode(sourceImage.buffer.asUint8List()),
      'models': [
        'stable_diffusion',
      ],
    };

    // Make a POST request with the json data
    final response = await http.post(
      Uri.parse('https://stablehorde.net/api/v2/generate/async'),
      headers: headers,
      body: jsonEncode(json),
    );

    if (response.statusCode != 202) {
      throw Exception('Failed to request diffusion: '
          '${response.statusCode} ${response.body}');
    }
    final jsonResponse = jsonDecode(response.body);

    final requestId = jsonResponse['request_id'];
    _requestIds.add(requestId);
  }
}

final stableHordeBloc = _StableHordeBloc();
