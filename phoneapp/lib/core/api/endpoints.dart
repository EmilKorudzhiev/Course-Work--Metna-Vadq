class Endpoints {
  //API
  static const _API_URL = 'http://192.168.43.152:8080';
  static const _API_VERSION = '/api/v1';
  static const URL = _API_URL + _API_VERSION;

  //ENDPOINTS
  //Auth
  static const LOGIN_ENDPOINT = '$URL/auth/authenticate';
  static const REGISTER_ENDPOINT = '$URL/auth/register';
  static const REFRESH_TOKEN_ENDPOINT = '$URL/auth/refresh';

  //User
  static const GET_USER_PROFILE = '$URL/user';
  static const GET_USER_POSTS = '$URL/fish-catch/user';

  //Fish catches
  static const GET_POSTS_PAGEABLE_ENDPOINT = '$URL/fish-catch';
  static const GET_POST_ENDPOINT = '$URL/fish-catch';
  static const GET_POSTS_BY_RADIUS_ENDPOINT = '$URL/fish-catch/find-in-radius';
  static const ADD_POST_ENDPOINT = '$URL/fish-catch';

  //Fish catches comments
  static const GET_COMMENTS_PAGEABLE_ENDPOINT = '$URL/comment';
  static const ADD_COMMENT_ENDPOINT = '$URL/comment';

  //Fish catches likes
  static const LIKE_POST_ENDPOINT = '$URL/user/like/fish-catch';

  //Locations
  static const GET_LOCATIONS_PAGEABLE_ENDPOINT = '$URL/location';
  static const GET_LOCATIONS_BY_RADIUS_ENDPOINT = '$URL/location/find-in-radius';
}