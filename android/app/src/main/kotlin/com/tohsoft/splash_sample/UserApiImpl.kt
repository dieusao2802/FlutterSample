package com.tohsoft.splash_sample

import UserNativeApi
import UserPigeon

class UserApiImpl : UserNativeApi {
    override fun saveUserToNative(user: UserPigeon) {

    }

    override fun getUserFromNative(): UserPigeon {
        return UserPigeon("Sao Dieu", "mmt1@gmail.com", "mmt99511")
    }
}
