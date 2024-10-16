import { client, type ByPage, type PaginationParams } from './common'
import { ApiException, ApiExceptionCode } from './common/exception'

export type User = {
  /** Unique identifier */
  id: string
  /** Creation timestamp */
  createdAt: string
  /** Last update timestamp */
  updatedAt: string
  /** Unique username of the user */
  username: string
  /** Brief bio or description of the user */
  description: string
  /** Name to display, TODO: from Casdoor? */
  displayName: string
  /** Avatar URL, TODO: from Casdoor? */
  avatar: string
}

// TODO: remove me
function __adaptUser(user: Omit<User, 'displayName' | 'avatar'>): User {
  return {
    displayName: user.username,
    avatar: 'https://avatars.githubusercontent.com/u/1492263?v=4',
    ...user
  }
}

export async function getUser(name: string): Promise<User> {
  return __adaptUser(await (client.get(`/user/${encodeURIComponent(name)}`) as Promise<User>))
}

export type UpdateProfileParams = Pick<User, 'description'>

export async function updateProfile(params: UpdateProfileParams) {
  return __adaptUser(await (client.put(`/user`, params) as Promise<User>))
}

export type ListUserParams = PaginationParams & {
  /** Filter users who are being followed by the specified user */
  follower?: string
  /** Filter users who are following the specified user */
  followee?: string
  /** Field by which to order the results */
  orderBy?: 'createdAt' | 'updatedAt' | 'followedAt'
  /** Order in which to sort the results */
  sortOrder?: 'asc' | 'desc'
}

export async function listUsers(params: ListUserParams) {
  const { total, data } = await (client.get('/users/list', params) as Promise<ByPage<User>>)
  return {
    total,
    data: data.map(__adaptUser)
  }
}

/**
 * Check given user followed by current logged-in user.
 * If not logged in, `false` will be returned.
 */
export async function isFollowing(username: string) {
  try {
    await client.get(`/user/${encodeURIComponent(username)}/following`)
    return true
  } catch (e) {
    if (e instanceof ApiException) {
      // Not followed. TODO: reconfirm value of `code` here
      if (e.code === ApiExceptionCode.errorNotFound) return false
      // Not logged in.
      if (e.code === ApiExceptionCode.errorUnauthorized) return false
      throw e
    }
    throw e
  }
}

export async function follow(username: string) {
  await client.post(`/user/${encodeURIComponent(username)}/following`)
}

export async function unfollow(username: string) {
  await client.delete(`/user/${encodeURIComponent(username)}/following`)
}